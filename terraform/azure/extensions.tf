resource "azurerm_virtual_machine_extension" "dotnet_deploy" {
    name                 = "deploy-${var.application}-${var.environment}"
    virtual_machine_id   = azurerm_windows_virtual_machine.vm.id
    publisher            = "Microsoft.Compute"
    type                 = "CustomScriptExtension"
    type_handler_version = "1.10"

    settings = <<SETTINGS
    {
    "fileUris": [
    "https://raw.githubusercontent.com/<your-user>/<your-repo>/<branch>/setup-dotnet-site.ps1"
    ],
    "commandToExecute": "powershell -ExecutionPolicy Unrestricted -File setup-dotnet-site.ps1"
    }
    SETTINGS
}
