# Install IIS and necessary features
Install-WindowsFeature -Name Web-Server, Web-Asp-Net45, Web-ISAPI-Ext, Web-ISAPI-Filter, Web-Mgmt-Console -IncludeManagementTools

# Install .NET 8 Hosting Bundle
Invoke-WebRequest -Uri "https://download.visualstudio.microsoft.com/download/pr/7f40b42c-4e4d-43ab-8f23-82e8e2a3e1f7/7a1e274a7d24508e139c1ff276013e8a/dotnet-hosting-8.0.5-win.exe" -OutFile "C:\dotnet-hosting.exe"
Start-Process -FilePath "C:\dotnet-hosting.exe" -ArgumentList "/quiet" -Wait

# Download the ZIP containing the .NET published site
Invoke-WebRequest -Uri "https://github.com/curious-jordan2/CuriousJordanMSWebApp/raw/refs/heads/dev/terraform/azure/dotnetapp.zip" -OutFile "C:\dotnetapp.zip"

# Create the destination directory
$sitePath = "C:\inetpub\wwwroot\CJP"
New-Item -Path $sitePath -ItemType Directory -Force

# Extract the application
Expand-Archive -Path "C:\dotnetapp.zip" -DestinationPath $sitePath -Force

# Ensure web.config is present at root and DLL path is correct in it (manual check or zip structure control)

# Create logs directory and set permissions
$logPath = Join-Path $sitePath "logs"
New-Item -Path $logPath -ItemType Directory -Force

# Set permissions for IIS to serve files and write logs
$AppPoolUser = "IIS AppPool\CJPPool"
icacls $sitePath /grant "IIS_IUSRS:(OI)(CI)(RX)" /T
icacls $sitePath /grant "IUSR:(OI)(CI)(RX)" /T
icacls $sitePath /grant "NETWORK SERVICE:(OI)(CI)(RX)" /T
icacls $sitePath /grant "${AppPoolUser}:(OI)(CI)(RX)" /T
icacls $logPath /grant "${AppPoolUser}:(OI)(CI)(M)" /T

# Remove Default Web Site if it exists
Remove-Website -Name "Default Web Site" -ErrorAction SilentlyContinue

# Create application pool
Import-Module WebAdministration
New-WebAppPool -Name "CJPPool" -Force
Set-ItemProperty IIS:\AppPools\CJPPool -Name managedRuntimeVersion -Value ""  # No Managed Code for .NET Core
Set-ItemProperty IIS:\AppPools\CJPPool -Name processModel.identityType -Value "ApplicationPoolIdentity"

# Create website bound to port 80
New-Website -Name "CJP" -Port 80 -PhysicalPath $sitePath -ApplicationPool "CJPPool"

# Final output for verification
Write-Host "`nDeployment complete. Site should now be accessible on port 80."
Get-Website -Name "CJP"
Get-WebAppPoolState -Name "CJPPool"
