# This document provides instructions for deploying this webapp.

## Use this powershell command to validate deployment template for the website:

```powershell

az deployment group validate --resource-group CuriosJordanPortfolioRG --template-file azuredeploy.json --parameters vmName=CuriousJordanNP adminUsername=adminUsername adminPassword=adminPassword dnsNameForPublicIP=curiousjordannp

az deployment group create --resource-group CuriosJordanPortfolioRG --template-file azuredeploy.json --parameters vmName=CuriousJordanNP adminUsername=curiousjordanadmin adminPassword=DO4bdJUDyYt1FR dnsNameForPublicIP=curiousjordannp

New-SelfSignedCertificate -CertStoreLocation Cert:\LocalMachine\My -DnsName "curiousjordannp.centralus.cloudapp.azure.com"

https://curiousjordannp.centralus.cloudapp.azure.com:8172/MsDeploy.axd


```