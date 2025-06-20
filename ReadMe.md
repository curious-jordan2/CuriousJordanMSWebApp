# This document provides instructions for deploying this webapp.

## Use this powershell command to validate deployment template for the website:

```powershell

az deployment group validate --resource-group CuriosJordanPortfolioRG --template-file azuredeploy.json --parameters vmName=CuriousJordanNP adminUsername=adminUsername adminPassword=adminPassword dnsNameForPublicIP=curiousjordannp

az deployment group create --resource-group CuriosJordanPortfolioRG --template-file azuredeploy.json --parameters vmName=CuriousJordanNP adminUsername=curiousjordanadmin adminPassword=DO4bdJUDyYt1FR dnsNameForPublicIP=curiousjordannp

New-SelfSignedCertificate -CertStoreLocation Cert:\LocalMachine\My -DnsName "curiousjordannp.centralus.cloudapp.azure.com"

https://curiousjordannp.centralus.cloudapp.azure.com:8172/MsDeploy.axd


```

## Publish app to root directory, Terraform Azure directory, or Terraform Docker directory
```pwsh
# publish to root directory
dotnet publish "C:\Users\jorda\Documents\Github\CuriousJordanMSWebApp\CuriousJordanMSWebApp" -c Release -o C:\Users\jorda\Documents\Github\CuriousJordanMSWebApp\publish
```
```pwsh
# publish to erraform Azure directory
dotnet publish "C:\Users\jorda\Documents\Github\CuriousJordanMSWebApp\CuriousJordanMSWebApp" -c Release -o C:\Users\jorda\Documents\Github\CuriousJordanMSWebApp\terraform\azure\publish
# zip files
cd .\publish\
Compress-Archive * ..\dotnetapp.zip
```
```pwsh
# publish to Terraform Docker directory
dotnet publish "C:\Users\jorda\Documents\Github\CuriousJordanMSWebApp\CuriousJordanMSWebApp" -c Release -o C:\Users\jorda\Documents\Github\CuriousJordanMSWebApp\terraform\docker\publish
```