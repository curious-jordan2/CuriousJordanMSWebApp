# Configure the VM extension to install IIS and Web Deploy
resource "azurerm_virtual_machine_extension" "web_server" {
  name                 = "InstallWebServer"
  virtual_machine_id   = azurerm_windows_virtual_machine.vm.id
  publisher            = "Microsoft.Compute"
  type                 = "CustomScriptExtension"
  type_handler_version = "1.10"
  auto_upgrade_minor_version = true

  settings = jsonencode({
    commandToExecute = "powershell -ExecutionPolicy Unrestricted -Command \"Install-WindowsFeature Web-Server,Web-Asp-Net45,NET-Framework-45-Features,Web-Net-Ext45,Web-ISAPI-Ext,Web-ISAPI-Filter,Web-Mgmt-Console,Web-Scripting-Tools,Web-Mgmt-Service; Invoke-WebRequest -Uri https://go.microsoft.com/fwlink/?linkid=2085767 -OutFile C:\\WebDeploy.msi; Start-Process msiexec.exe -ArgumentList '/i C:\\WebDeploy.msi /quiet' -Wait; Set-Service -Name WMSVC -StartupType Automatic; Start-Service WMSVC\""
  })
}


resource "azurerm_virtual_machine_extension" "web_app_deploy" {
  name                 = "WebAppDeployScript"
  virtual_machine_id  = azurerm_windows_virtual_machine.vm.id
  publisher           = "Microsoft.Compute"
  type                = "CustomScriptExtension"
  type_handler_version = "1.10"
  auto_upgrade_minor_version = true

  settings = jsonencode({
    commandToExecute = "powershell -ExecutionPolicy Unrestricted -File C:\\scripts\\deploy.ps1"
  })

  depends_on = [azurerm_windows_virtual_machine.vm]
}