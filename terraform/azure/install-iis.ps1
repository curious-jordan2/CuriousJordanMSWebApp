# # ----------------------------
# # 1. Install IIS & Required Features
# # ----------------------------
# Install-WindowsFeature -Name Web-Server, Web-Asp-Net45, Web-ISAPI-Ext, Web-ISAPI-Filter, Web-Mgmt-Console -IncludeManagementTools

# # ----------------------------
# # 2. Install .NET 8 Hosting Bundle
# # ----------------------------
# Invoke-WebRequest -Uri "https://download.visualstudio.microsoft.com/download/pr/7f40b42c-4e4d-43ab-8f23-82e8e2a3e1f7/7a1e274a7d24508e139c1ff276013e8a/dotnet-hosting-8.0.5-win.exe" -OutFile "C:\dotnet-hosting.exe"
# Start-Process -FilePath "C:\dotnet-hosting.exe" -ArgumentList "/quiet" -Wait

# # ----------------------------
# # 3. Download and Deploy .NET App
# # ----------------------------
# Invoke-WebRequest -Uri "https://github.com/curious-jordan2/CuriousJordanMSWebApp/raw/refs/heads/dev/terraform/azure/dotnetapp.zip" -OutFile "C:\dotnetapp.zip"

# $sitePath = "C:\inetpub\wwwroot\CJP"
# New-Item -Path $sitePath -ItemType Directory -Force
# Expand-Archive -Path "C:\dotnetapp.zip" -DestinationPath $sitePath -Force

# # ----------------------------
# # 4. Create Logs Directory
# # ----------------------------
# $logPath = "$sitePath\logs"
# New-Item -ItemType Directory -Path $logPath -Force

# # ----------------------------
# # 5. Set Permissions for App Pool and IIS
# # ----------------------------
# $AppPoolUser = "IIS AppPool\CJPPool"
# icacls $sitePath /grant "IIS_IUSRS:(OI)(CI)(RX)" /T
# icacls $sitePath /grant "IUSR:(OI)(CI)(RX)" /T
# icacls $sitePath /grant "NETWORK SERVICE:(OI)(CI)(RX)" /T
# icacls $sitePath /grant "${AppPoolUser}:(OI)(CI)(RX)" /T
# icacls $logPath /grant "${AppPoolUser}:(OI)(CI)(M)" /T

# # ----------------------------
# # 6. Configure IIS Site & App Pool
# # ----------------------------
# Import-Module WebAdministration
# Remove-Website -Name "Default Web Site" -ErrorAction SilentlyContinue

# New-WebAppPool -Name "CJPPool" -Force
# Set-ItemProperty IIS:\AppPools\CJPPool -Name managedRuntimeVersion -Value ""
# Set-ItemProperty IIS:\AppPools\CJPPool -Name processModel.identityType -Value "ApplicationPoolIdentity"

# New-Website -Name "CJP" -Port 80 -PhysicalPath $sitePath -ApplicationPool "CJPPool"

# # ----------------------------
# # 7. Install and Configure OpenSSH for Password Login
# # ----------------------------
# # Install OpenSSH Server if not already installed
# Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0

# # Start and enable OpenSSH service
# Start-Service sshd
# Set-Service -Name sshd -StartupType 'Automatic'

# # Set PowerShell as the default shell for SSH
# New-ItemProperty -Path "HKLM:\SOFTWARE\OpenSSH" -Name DefaultShell -Value "C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe" -PropertyType String -Force

# # Allow SSH through firewall
# New-NetFirewallRule -Name sshd -DisplayName "OpenSSH Server (Port 22)" -Enabled True -Protocol TCP -Direction Inbound -Action Allow -LocalPort 22

# # Modify sshd_config to allow password authentication
# $sshdConfigPath = "$env:ProgramData\ssh\sshd_config"
# (Get-Content $sshdConfigPath) `
#     -replace '^#?PasswordAuthentication no', 'PasswordAuthentication yes' `
#     -replace '^#?PubkeyAuthentication no', 'PubkeyAuthentication yes' `
#     | Set-Content $sshdConfigPath

# Restart-Service sshd

# # ----------------------------
# # 8. Output Deployment Status
# # ----------------------------
# Write-Host "`Deployment complete. Site should be accessible at http://<VM-IP>"
# Write-Host "SSH login is enabled on port 22 using VM's local username and password."
# Write-Host "You can now SSH with: ssh <username>@<VM-IP>"