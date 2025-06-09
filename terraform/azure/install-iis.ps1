# Install IIS
Install-WindowsFeature -Name Web-Server -IncludeManagementTools

# Install .NET 8 Hosting Bundle
Invoke-WebRequest -Uri "https://download.visualstudio.microsoft.com/download/pr/7f40b42c-4e4d-43ab-8f23-82e8e2a3e1f7/7a1e274a7d24508e139c1ff276013e8a/dotnet-hosting-8.0.5-win.exe" -OutFile "C:\dotnet-hosting.exe"
Start-Process -FilePath "C:\dotnet-hosting.exe" -ArgumentList "/quiet" -Wait

# Download the zip from GitHub
Invoke-WebRequest -Uri "https://github.com/curious-jordan2/CuriousJordanMSWebApp/raw/refs/heads/dev/terraform/azure/dotnetapp.zip" -OutFile "C:\dotnetapp.zip"

# Create the folder
New-Item -Path "C:\inetpub\wwwroot\CJP" -ItemType Directory -Force

# Extract zip
Expand-Archive -Path "C:\dotnetapp.zip" -DestinationPath "C:\inetpub\wwwroot\CJP" -Force

# Remove Default Web Site
Remove-Website -Name "Default Web Site" -ErrorAction SilentlyContinue

# Set up IIS site and app pool
Import-Module WebAdministration
New-WebAppPool -Name "CJPPool"
Set-ItemProperty IIS:\AppPools\CJPPool -Name managedRuntimeVersion -Value ""

New-Website -Name "CJP" -Port 80 -PhysicalPath "C:\inetpub\wwwroot\CJP" -ApplicationPool "CJPPool"