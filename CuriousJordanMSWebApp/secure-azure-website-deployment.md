# Deploying a Secure Website to Azure with ARM Templates, .NET, and IIS

This guide walks through the complete process of creating and deploying a secure website on Azure using ARM templates, .NET, and IIS. It's designed for those new to .NET development.

## 1. Setting Up Your Development Environment

First, you need to install the necessary tools on your local machine:

### Install Visual Studio 2022
1. Download Visual Studio 2022 Community Edition (free) from [Visual Studio website](https://visualstudio.microsoft.com/vs/community/)
2. Run the installer
3. Select the following workloads:
   - ASP.NET and web development
   - Azure development
   - .NET desktop development
4. Complete the installation process

### Install Azure CLI
1. Download the Azure CLI installer from [Microsoft's official page](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli)
2. Run the installer and follow the prompts
3. Verify installation by opening a command prompt and running:
   ```
   az --version
   ```

### Install Git (Optional but Recommended)
1. Download Git from [git-scm.com](https://git-scm.com/downloads)
2. Run the installer with default options
3. Verify installation by opening a command prompt and running:
   ```
   git --version
   ```

## 2. Creating a Simple .NET Web Application

Now, let's create a basic ASP.NET Core web application:

1. Open Visual Studio 2022
2. Click "Create a new project"
3. Select "ASP.NET Core Web App" (make sure it's the C# version)
4. Click "Next"
5. Enter these project details:
   - Project name: `SecureAzureWebsite`
   - Location: Choose your preferred folder
   - Solution name: `SecureAzureWebsite`
6. Click "Next"
7. On the additional information screen:
   - Select .NET 8.0 (or the latest LTS version)
   - Enable HTTPS
   - Disable Docker support (unless you specifically want to use it)
8. Click "Create"

Visual Studio will generate a simple web application with a default home page. Let's add a simple custom page:

1. In Solution Explorer, right-click on the "Pages" folder
2. Select Add > Razor Page
3. Name it "HelloAzure"
4. Click "Add"
5. Replace the content of "HelloAzure.cshtml" with:

```html
@page
@model SecureAzureWebsite.Pages.HelloAzureModel
@{
    ViewData["Title"] = "Hello Azure";
}

<div class="text-center">
    <h1 class="display-4">Hello Azure!</h1>
    <p>This is a simple secure website deployed on Azure using ARM templates and IIS.</p>
    <p>Current time on the server is: @DateTime.Now</p>
</div>
```

6. Update the navigation in `Pages/Shared/_Layout.cshtml`. Find the navigation section and add this link:

```html
<li class="nav-item">
    <a class="nav-link text-dark" asp-area="" asp-page="/HelloAzure">Hello Azure</a>
</li>
```

7. Test your application locally:
   - Press F5 or click the "Run" button
   - The web application should open in a browser
   - Navigate to the "Hello Azure" page via the link

8. Build the application for publishing:
   - Right-click on the project in Solution Explorer
   - Select Publish
   - Choose "Folder" as the publish target
   - Set the folder path (e.g., `C:\Deployments\SecureAzureWebsite`)
   - Click "Finish"
   - Click "Publish" on the profile page

This will create a published version of your application ready for deployment.

## 3. Preparing Your Azure Subscription

Before deploying, you need to set up your Azure environment:

1. Sign in to the Azure portal at [portal.azure.com](https://portal.azure.com)
2. If you don't have an Azure subscription, create a free account
3. Open a command prompt or PowerShell window
4. Log in to Azure CLI:
   ```
   az login
   ```
5. Create a resource group for your deployment:
   ```
   az group create --name SecureWebsiteRG --location eastus
   ```

## 4. Creating an ARM Template for Deployment

Now, let's create an ARM template to provision our infrastructure. Create a file named `azuredeploy.json` with the following content:

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    "vmName": {
      "type": "string",
      "defaultValue": "SecureWebVM",
      "metadata": {
        "description": "Name for the Virtual Machine"
      }
    },
    "adminUsername": {
      "type": "string",
      "metadata": {
        "description": "Username for the Virtual Machine administrator"
      }
    },
    "adminPassword": {
      "type": "securestring",
      "metadata": {
        "description": "Password for the Virtual Machine administrator"
      }
    },
    "dnsNameForPublicIP": {
      "type": "string",
      "metadata": {
        "description": "Unique DNS Name for the Public IP used to access the Virtual Machine"
      }
    },
    "windowsOSVersion": {
      "type": "string",
      "defaultValue": "2022-datacenter-azure-edition",
      "metadata": {
        "description": "The Windows version for the VM"
      }
    },
    "vmSize": {
      "type": "string",
      "defaultValue": "Standard_D2s_v3",
      "metadata": {
        "description": "Size of the Virtual Machine"
      }
    }
  },
  "variables": {
    "storageAccountName": "[concat('storage', uniqueString(resourceGroup().id))]",
    "nicName": "[concat(parameters('vmName'), 'Nic')]",
    "addressPrefix": "10.0.0.0/16",
    "subnetName": "Subnet",
    "subnetPrefix": "10.0.0.0/24",
    "publicIPAddressName": "[concat(parameters('vmName'), 'PublicIP')]",
    "virtualNetworkName": "[concat(parameters('vmName'), 'VNET')]",
    "subnetRef": "[resourceId('Microsoft.Network/virtualNetworks/subnets', variables('virtualNetworkName'), variables('subnetName'))]",
    "networkSecurityGroupName": "[concat(parameters('vmName'), 'NSG')]"
  },
  "resources": [
    {
      "type": "Microsoft.Storage/storageAccounts",
      "name": "[variables('storageAccountName')]",
      "apiVersion": "2021-04-01",
      "location": "[resourceGroup().location]",
      "sku": {
        "name": "Standard_LRS"
      },
      "kind": "StorageV2"
    },
    {
      "type": "Microsoft.Network/publicIPAddresses",
      "name": "[variables('publicIPAddressName')]",
      "apiVersion": "2021-02-01",
      "location": "[resourceGroup().location]",
      "properties": {
        "publicIPAllocationMethod": "Dynamic",
        "dnsSettings": {
          "domainNameLabel": "[parameters('dnsNameForPublicIP')]"
        }
      }
    },
    {
      "type": "Microsoft.Network/networkSecurityGroups",
      "name": "[variables('networkSecurityGroupName')]",
      "apiVersion": "2021-02-01",
      "location": "[resourceGroup().location]",
      "properties": {
        "securityRules": [
          {
            "name": "default-allow-rdp",
            "properties": {
              "priority": 1000,
              "access": "Allow",
              "direction": "Inbound",
              "destinationPortRange": "3389",
              "protocol": "Tcp",
              "sourcePortRange": "*",
              "sourceAddressPrefix": "*",
              "destinationAddressPrefix": "*"
            }
          },
          {
            "name": "default-allow-http",
            "properties": {
              "priority": 1001,
              "access": "Allow",
              "direction": "Inbound",
              "destinationPortRange": "80",
              "protocol": "Tcp",
              "sourcePortRange": "*",
              "sourceAddressPrefix": "*",
              "destinationAddressPrefix": "*"
            }
          },
          {
            "name": "default-allow-https",
            "properties": {
              "priority": 1002,
              "access": "Allow",
              "direction": "Inbound",
              "destinationPortRange": "443",
              "protocol": "Tcp",
              "sourcePortRange": "*",
              "sourceAddressPrefix": "*",
              "destinationAddressPrefix": "*"
            }
          }
        ]
      }
    },
    {
      "type": "Microsoft.Network/virtualNetworks",
      "name": "[variables('virtualNetworkName')]",
      "apiVersion": "2021-02-01",
      "location": "[resourceGroup().location]",
      "properties": {
        "addressSpace": {
          "addressPrefixes": [
            "[variables('addressPrefix')]"
          ]
        },
        "subnets": [
          {
            "name": "[variables('subnetName')]",
            "properties": {
              "addressPrefix": "[variables('subnetPrefix')]",
              "networkSecurityGroup": {
                "id": "[resourceId('Microsoft.Network/networkSecurityGroups', variables('networkSecurityGroupName'))]"
              }
            }
          }
        ]
      },
      "dependsOn": [
        "[resourceId('Microsoft.Network/networkSecurityGroups', variables('networkSecurityGroupName'))]"
      ]
    },
    {
      "type": "Microsoft.Network/networkInterfaces",
      "name": "[variables('nicName')]",
      "apiVersion": "2021-02-01",
      "location": "[resourceGroup().location]",
      "properties": {
        "ipConfigurations": [
          {
            "name": "ipconfig1",
            "properties": {
              "privateIPAllocationMethod": "Dynamic",
              "publicIPAddress": {
                "id": "[resourceId('Microsoft.Network/publicIPAddresses', variables('publicIPAddressName'))]"
              },
              "subnet": {
                "id": "[variables('subnetRef')]"
              }
            }
          }
        ]
      },
      "dependsOn": [
        "[resourceId('Microsoft.Network/publicIPAddresses', variables('publicIPAddressName'))]",
        "[resourceId('Microsoft.Network/virtualNetworks', variables('virtualNetworkName'))]"
      ]
    },
    {
      "type": "Microsoft.Compute/virtualMachines",
      "name": "[parameters('vmName')]",
      "apiVersion": "2021-03-01",
      "location": "[resourceGroup().location]",
      "properties": {
        "hardwareProfile": {
          "vmSize": "[parameters('vmSize')]"
        },
        "osProfile": {
          "computerName": "[parameters('vmName')]",
          "adminUsername": "[parameters('adminUsername')]",
          "adminPassword": "[parameters('adminPassword')]"
        },
        "storageProfile": {
          "imageReference": {
            "publisher": "MicrosoftWindowsServer",
            "offer": "WindowsServer",
            "sku": "[parameters('windowsOSVersion')]",
            "version": "latest"
          },
          "osDisk": {
            "name": "[concat(parameters('vmName'), '_OSDisk')]",
            "caching": "ReadWrite",
            "createOption": "FromImage",
            "managedDisk": {
              "storageAccountType": "Premium_LRS"
            }
          }
        },
        "networkProfile": {
          "networkInterfaces": [
            {
              "id": "[resourceId('Microsoft.Network/networkInterfaces', variables('nicName'))]"
            }
          ]
        },
        "diagnosticsProfile": {
          "bootDiagnostics": {
            "enabled": true,
            "storageUri": "[reference(resourceId('Microsoft.Storage/storageAccounts', variables('storageAccountName'))).primaryEndpoints.blob]"
          }
        }
      },
      "dependsOn": [
        "[resourceId('Microsoft.Storage/storageAccounts', variables('storageAccountName'))]",
        "[resourceId('Microsoft.Network/networkInterfaces', variables('nicName'))]"
      ]
    },
    {
      "type": "Microsoft.Compute/virtualMachines/extensions",
      "name": "[concat(parameters('vmName'),'/InstallWebServer')]",
      "apiVersion": "2021-03-01",
      "location": "[resourceGroup().location]",
      "properties": {
        "publisher": "Microsoft.Compute",
        "type": "CustomScriptExtension",
        "typeHandlerVersion": "1.10",
        "autoUpgradeMinorVersion": true,
        "settings": {
          "commandToExecute": "powershell -ExecutionPolicy Unrestricted Install-WindowsFeature -Name Web-Server,Web-Asp-Net45,NET-Framework-45-Features,Web-Net-Ext45,Web-ISAPI-Ext,Web-ISAPI-Filter,Web-Mgmt-Console,Web-Scripting-Tools,Web-Mgmt-Service"
        }
      },
      "dependsOn": [
        "[resourceId('Microsoft.Compute/virtualMachines', parameters('vmName'))]"
      ]
    }
  ],
  "outputs": {
    "hostname": {
      "type": "string",
      "value": "[reference(variables('publicIPAddressName')).dnsSettings.fqdn]"
    },
    "ipAddress": {
      "type": "string",
      "value": "[reference(variables('publicIPAddressName')).ipAddress]"
    }
  }
}
```

Create a parameters file named `azuredeploy.parameters.json`:

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    "adminUsername": {
      "value": "azureadmin"
    },
    "adminPassword": {
      "reference": {
        "keyVault": {
          "id": "/subscriptions/{subscription-id}/resourceGroups/{resource-group}/providers/Microsoft.KeyVault/vaults/{vault-name}"
        },
        "secretName": "adminPassword"
      }
    },
    "dnsNameForPublicIP": {
      "value": "yourwebsitedns"
    }
  }
}
```

> Note: For production, you should use Azure Key Vault to securely store and reference your password. For this example, you can directly provide a secure password value when deploying.

## 5. Deploying the ARM Template to Azure

Now let's deploy the ARM template to create our infrastructure:

1. Open a command prompt or PowerShell window
2. Navigate to the folder containing your ARM template files
3. Deploy the template using Azure CLI:

```
az deployment group create --resource-group SecureWebsiteRG --template-file azuredeploy.json --parameters vmName=SecureWebVM adminUsername=azureadmin adminPassword=YourComplexPassword123! dnsNameForPublicIP=yourwebsitedns
```

> Replace `YourComplexPassword123!` with a secure password that meets Azure requirements (12+ characters with mix of uppercase, lowercase, numbers, and special characters)

> Replace `yourwebsitedns` with a unique DNS name of your choice (it will become `yourwebsitedns.eastus.cloudapp.azure.com`)

This deployment will take 5-10 minutes to complete. It creates:
- A virtual network and subnet
- A network security group with rules for RDP, HTTP, and HTTPS
- A Windows Server 2022 virtual machine
- Installs IIS and ASP.NET on the virtual machine

## 6. Deploying Your Web Application to the Azure VM

Once the VM is deployed, you need to get your web application onto it:

1. Get the public IP address of your VM:
   ```
   az vm show -d -g SecureWebsiteRG -n SecureWebVM --query publicIps -o tsv
   ```

2. Connect to the VM using Remote Desktop:
   - On Windows: Use the built-in Remote Desktop Connection app
   - On Mac: Download Microsoft Remote Desktop from the App Store
   - On the connection dialog, enter the IP address from step 1
   - When prompted, use the admin username and password you specified during deployment

3. On the VM, create a folder for your website:
   - Open File Explorer
   - Navigate to `C:\inetpub\`
   - Create a new folder called `SecureAzureWebsite`

4. Copy your web application files to the VM:
   - Option 1: Use a file sharing service like OneDrive, Dropbox, or Azure Storage
   - Option 2: Create a ZIP file of your web application, copy it to the VM, and extract it
   - Option 3: Use Remote Desktop file transfer:
     - On the Remote Desktop Connection app, click "Show Options"
     - Go to the "Local Resources" tab
     - Click "More..." under "Local devices and resources"
     - Check "Drives" to share your local drives with the remote session
     - Connect to the VM
     - Copy from your local drive to the VM

5. Copy all files from your published web application folder (e.g., `C:\Deployments\SecureAzureWebsite`) to `C:\inetpub\SecureAzureWebsite` on the VM.

## 7. Configuring IIS and SSL for Secure Hosting

Now let's configure IIS to host our website securely:

1. On the VM, open Server Manager (it should start automatically)
2. Click "Tools" in the top-right corner, then "Internet Information Services (IIS) Manager"
3. In IIS Manager, expand the server name in the left panel
4. Right-click on "Sites" and select "Add Website"
5. Fill in the website details:
   - Site name: `SecureAzureWebsite`
   - Physical path: `C:\inetpub\SecureAzureWebsite`
   - Binding: Select HTTPS, port 443
   - SSL certificate: Click "Create Self-Signed Certificate"
   - In the certificate dialog, enter a friendly name like "SecureAzureWebsite-Cert"
   - Click "OK" to create the website

6. Add an HTTP to HTTPS redirect:
   - In IIS Manager, click on your new site
   - Double-click on "URL Rewrite" in the Features view
   - Click "Add Rule(s)" in the right panel
   - Select "Blank rule" under "Inbound rules"
   - Configure the rule:
     - Name: `HTTP to HTTPS Redirect`
     - Pattern: `(.*)`
     - Action type: `Redirect`
     - Redirect URL: `https://{HTTP_HOST}/{R:1}`
     - Redirect type: `Permanent (301)`
   - Click "Apply" in the right panel

7. Add the application pool for .NET:
   - In IIS Manager, expand your server and click on "Application Pools"
   - Right-click and select "Add Application Pool"
   - Name: `SecureAzureWebsiteAppPool`
   - .NET CLR version: `.NET CLR v4.0.30319`
   - Managed pipeline mode: `Integrated`
   - Click "OK"
   
8. Assign the application pool to your website:
   - In IIS Manager, click on your website
   - In the Actions pane on the right, click "Basic Settings"
   - Click "Select..." next to Application Pool
   - Choose `SecureAzureWebsiteAppPool`
   - Click "OK" twice

9. Configure application settings:
   - In IIS Manager, click on your website
   - Double-click on "Application Settings"
   - Add any necessary application settings for your web app

10. Set appropriate permissions:
    - Open File Explorer
    - Right-click on `C:\inetpub\SecureAzureWebsite` and select "Properties"
    - Go to the "Security" tab
    - Click "Edit" to modify permissions
    - Click "Add" and enter `IIS_IUSRS`
    - Click "Check Names" and then "OK"
    - Select the IIS_IUSRS group
    - Check "Read & execute", "List folder contents", and "Read" permissions
    - Click "OK" twice

11. Test your website:
    - Open a web browser on your VM
    - Navigate to `https://localhost`
    - You should see your website running
    - You might get a certificate warning, which is expected for self-signed certificates

## 8. Accessing Your Website from the Internet

Your website is now running and accessible from the internet:

1. From any computer, open a web browser
2. Navigate to your website using the DNS name you specified:
   `https://yourwebsitedns.eastus.cloudapp.azure.com`

3. You will get a certificate warning because the self-signed certificate isn't trusted by browsers. For a production website, you should:
   - Purchase a domain name
   - Get a trusted SSL certificate from a provider like Let's Encrypt or DigiCert
   - Configure IIS to use the trusted certificate

## 9. Production Considerations

For a production environment, consider these additional steps:

1. **Domain Name**: Purchase a custom domain from a registrar and configure it to point to your Azure VM's IP address.

2. **SSL Certificate**: Obtain a trusted SSL certificate for your domain. You can use:
   - Let's Encrypt (free)
   - Azure App Service Certificate (paid, managed by Azure)
   - Commercial certificate authority like DigiCert or Comodo

3. **Security Hardening**:
   - Restrict RDP access in the Network Security Group to specific IP addresses
   - Configure Windows Firewall on the VM
   - Use Azure Security Center for security recommendations
   - Set up regular Windows updates

4. **Monitoring and Backup**:
   - Configure Azure Backup for the VM
   - Set up Azure Monitor and Application Insights
   - Configure IIS logging and monitoring

5. **High Availability**:
   - For production workloads, consider using:
     - Azure App Service instead of a VM for easier management
     - Multiple VMs with a load balancer
     - Azure Traffic Manager for global routing

## Troubleshooting

If you encounter issues:

1. **Website not accessible**:
   - Verify the Network Security Group allows traffic on ports 80 and 443
   - Check that IIS is running on the VM (use IIS Manager)
   - Ensure your web application is in the correct directory

2. **Application errors**:
   - Check the Event Viewer on the VM for application errors
   - Enable detailed error messages in IIS
   - Verify the correct .NET Framework version is installed

3. **SSL certificate errors**:
   - Self-signed certificates will always show warnings in browsers
   - For production, replace with a trusted certificate

4. **Performance issues**:
   - Consider scaling up the VM size
   - Use Application Insights to identify bottlenecks

## Conclusion

You've successfully deployed a secure website on Azure using ARM templates, .NET, and IIS. The website is accessible via HTTPS and redirects HTTP traffic to HTTPS. For a production environment, you should acquire a custom domain name and a trusted SSL certificate.
