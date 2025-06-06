# Use official ASP.NET Core runtime image (you can adjust version)
FROM mcr.microsoft.com/windows/servercore:ltsc2022

WORKDIR /app

# Path relative to build context (which is the project root now)
COPY publish/ .

EXPOSE 80
ENTRYPOINT ["dotnet", "CuriousJordanMSWebApp.dll"]