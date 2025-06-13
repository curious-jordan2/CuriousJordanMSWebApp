# This document provides instructions for deploying this webapp.

# Prerequisites

## Install Required Packages
```pwsh
dotnet restore
```
```sh
dotnet restore
```

## Set Git Branch
Prior to beginning development or deploying you need to execute the setGitBranch powershell or bash files to set the current branch as an evironment variable

```powershell
.\setGitBranch.ps1
```

```bash
./script_name.sh
```


# Deploy Using ARM Templates
## Use this powershell command to validate deployment template for the website:

```powershell

az deployment group validate --resource-group CuriosJordanPortfolioRG --template-file azuredeploy.json --parameters vmName=CuriousJordanNP adminUsername=adminUsername adminPassword=adminPassword dnsNameForPublicIP=curiousjordannp

az deployment group create --resource-group CuriosJordanPortfolioRG --template-file azuredeploy.json --parameters vmName=CuriousJordanNP adminUsername=curiousjordanadmin adminPassword=DO4bdJUDyYt1FR dnsNameForPublicIP=curiousjordannp

New-SelfSignedCertificate -CertStoreLocation Cert:\LocalMachine\My -DnsName "curiousjordannp.centralus.cloudapp.azure.com"

https://curiousjordannp.centralus.cloudapp.azure.com:8172/MsDeploy.axd


```

# Deploy Using Terraform

## Docker Deployment

### Publish app to Terraform Docker directory
```pwsh
# publish to Terraform Docker directory
dotnet publish "C:\Users\jorda\Documents\Github\CuriousJordanMSWebApp\CuriousJordanMSWebApp" -c Release -o C:\Users\jorda\Documents\Github\CuriousJordanMSWebApp\terraform\docker\publish
```

## Deloy Using Azure

### Publish app to Terraform Azure directory
```pwsh
# publish to erraform Azure directory
dotnet publish "C:\Users\jorda\Documents\Github\CuriousJordanMSWebApp\CuriousJordanMSWebApp" -c Release -o C:\Users\jorda\Documents\Github\CuriousJordanMSWebApp\terraform\azure\publish
# zip files
cd .\publish\
Compress-Archive * ..\dotnetapp.zip
```

```pwsh
cd .\terraform\azure\
tf plan ## test deployment
tf apply ## live deployment
```