# Use official ASP.NET Core runtime image (you can adjust version)
FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base

WORKDIR /app

# Copy published output into container
COPY ../../publish/ .

# Expose the default port used by Kestrel
EXPOSE 80

# Start the app
ENTRYPOINT ["dotnet", "CuriousJordanMSWebApp.dll"]