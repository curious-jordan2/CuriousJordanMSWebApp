FROM mcr.microsoft.com/dotnet/aspnet:8.0-windowsservercore-ltsc2022

WORKDIR /app

COPY publish/ .

EXPOSE 8000

ENTRYPOINT ["dotnet", "CuriousJordanMSWebApp.dll"]