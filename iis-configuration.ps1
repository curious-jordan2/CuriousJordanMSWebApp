# ----------------------------
# 0. Define parameters
# ----------------------------
$siteDomain = "curiousjordan.club"
$siteName = "CJP"
$siteWebAppPoolName = "CJPPool"
$bindingInfo = "*:80:$siteDomain"
$bindingInfoWWW = "*:80:www.$siteDomain"
$gitBranch = 'add-domain-and-static-ip'

# ----------------------------
# 1. Install IIS & Required Features
# ----------------------------
Install-WindowsFeature -Name Web-Server, Web-Asp-Net45, Web-ISAPI-Ext, Web-ISAPI-Filter, Web-Mgmt-Console -IncludeManagementTools

# ----------------------------
# 2. Install .NET 8 Hosting Bundle
# ----------------------------
Invoke-WebRequest -Uri "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/8.0.17/dotnet-hosting-8.0.17-win.exe" -OutFile "C:\dotnet-hosting.exe"
Start-Process -FilePath "C:\dotnet-hosting.exe" -ArgumentList "/quiet" -Wait

# ----------------------------
# 3. Download and Deploy .NET App
# ----------------------------
Invoke-WebRequest -Uri "https://github.com/curious-jordan2/CuriousJordanMSWebApp/raw/refs/heads/$gitBranch/terraform/azure/dotnetapp.zip" -OutFile "C:\dotnetapp.zip"

$sitePath = "C:\inetpub\wwwroot\CJP"
New-Item -Path $sitePath -ItemType Directory -Force
Expand-Archive -Path "C:\dotnetapp.zip" -DestinationPath $sitePath -Force

# ----------------------------
# 4. Create Logs Directory
# ----------------------------
$logPath = "$sitePath\logs"
New-Item -ItemType Directory -Path $logPath -Force

# ----------------------------
# 5. Set Permissions for App Pool and IIS
# ----------------------------
$AppPoolUser = "IIS AppPool\CJPPool"
icacls $sitePath /grant "IIS_IUSRS:(OI)(CI)(RX)" /T
icacls $sitePath /grant "IUSR:(OI)(CI)(RX)" /T
icacls $sitePath /grant "NETWORK SERVICE:(OI)(CI)(RX)" /T
icacls $sitePath /grant "${AppPoolUser}:(OI)(CI)(RX)" /T
icacls $logPath /grant "${AppPoolUser}:(OI)(CI)(M)" /T

# ----------------------------
# 6. Configure IIS Site & App Pool
# ----------------------------

Import-Module WebAdministration
# Remove Default Website
Remove-Website -Name "Default Web Site" -ErrorAction SilentlyContinue
# Create New Web App Pool
New-WebAppPool -Name $siteWebAppPoolName  -Force
Set-ItemProperty IIS:\AppPools\CJPPool -Name managedRuntimeVersion -Value ""
Set-ItemProperty IIS:\AppPools\CJPPool -Name processModel.identityType -Value "ApplicationPoolIdentity"

New-Website -Name $siteName -Port 80 -PhysicalPath $sitePath -ApplicationPool $siteWebAppPoolName
# Add Web Binding
New-WebBinding -Name $siteName -Protocol "http" -BindingInformation $bindingInfo
New-WebBinding -Name $siteName -Protocol "http" -BindingInformation $bindingInfoWWW


iisreset