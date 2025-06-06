# Use this file to create your custom docker image

# Use Windows Server Core with IIS
FROM mcr.microsoft.com/windows/servercore:ltsc2022

# Install IIS
RUN dism.exe /online /enable-feature /all /featurename:IIS-WebServer

# Create a directory for the app
RUN mkdir C:\inetpub\myapp

# Copy your published ASP.NET app into the container
COPY dotnet publish "C:\Users\jorda\Documents\Github\CuriousJordanMSWebApp\CuriousJordanMSWebApp" -c Release -o C:\Users\jorda\Documents\Github\CuriousJordanMSWebApp\publish


# Set the site root to your app
RUN powershell -NoProfile -Command \
    Import-Module WebAdministration; \
    Set-ItemProperty 'IIS:\Sites\Default Web Site' -Name physicalPath -Value 'C:\inetpub\myapp'

# Expose HTTP
EXPOSE 80

# Start IIS
CMD ["powershell", "-NoProfile", "-Command", "Start-Service w3svc; while ($true) { Start-Sleep -Seconds 3600 }"]
