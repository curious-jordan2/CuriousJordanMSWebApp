Install-WindowsFeature -name Web-Server -IncludeManagementTools

# Create folder and deploy simple HTML or .NET app
New-Item -Path "C:\inetpub\wwwroot\index.html" -ItemType File -Force -Value "<h1>Hello from .NET 8 on IIS</h1>"

# Download the zip from GitHub
Invoke-WebRequest -Uri "https://github.com/curious-jordan2/CuriousJordanMSWebApp/raw/refs/heads/dev/terraform/azure/dotnetapp.zip" -OutFile "C:\dotnetapp.zip"

# Create the folder
New-Item -Path "C:\inetpub\wwwroot\CJP" -ItemType Directory -Force

# Extract zip
Expand-Archive -Path "C:\dotnetapp.zip" -DestinationPath "C:\inetpub\wwwroot\CJP" -Force

# Set up IIS site and app pool
Import-Module WebAdministration
New-WebAppPool -Name "CJPPool"
Set-ItemProperty IIS:\AppPools\CJPPool -Name managedRuntimeVersion -Value ""

New-Website -Name "CJP" -Port 80 -PhysicalPath "C:\inetpub\wwwroot\CJP" -ApplicationPool "CJPPool"
