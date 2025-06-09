Install-WindowsFeature -name Web-Server -IncludeManagementTools

# Create folder and deploy simple HTML or .NET app
New-Item -Path "C:\inetpub\wwwroot\index.html" -ItemType File -Force -Value "<h1>Hello from .NET 8 on IIS</h1>"
