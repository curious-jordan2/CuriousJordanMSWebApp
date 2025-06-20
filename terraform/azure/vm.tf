resource "azurerm_windows_virtual_machine" "vm" {
    name                = "${var.application}-${var.environment}"
    location            = var.location
    resource_group_name = azurerm_resource_group.rg.name
    size                = "Standard_B1ms" # Cheapest option
    admin_username      = var.admin_username
    admin_password      = var.admin_password
    network_interface_ids = [
    azurerm_network_interface.nic.id
    ]

    os_disk {
        caching              = "ReadWrite"
        storage_account_type = "Standard_LRS"
    }

    source_image_reference {
        publisher = "MicrosoftWindowsServer"
        offer     = "WindowsServer"
        sku       = "2022-Datacenter"
        version   = "latest"
    }

    provision_vm_agent = true

    tags = {
        environment = var.environment
    }
}

resource "azurerm_network_interface_security_group_association" "nsg_assoc" {
    network_interface_id      = azurerm_network_interface.nic.id
    network_security_group_id = azurerm_network_security_group.nsg.id
}

resource "azurerm_virtual_machine_extension" "iis_install" {
    name                 = "install-iis"
    virtual_machine_id   = azurerm_windows_virtual_machine.vm.id
    publisher            = "Microsoft.Compute"
    type                 = "CustomScriptExtension"
    type_handler_version = "1.10"

    settings = <<SETTINGS
{
    "fileUris": ["https://raw.githubusercontent.com/curious-jordan2/CuriousJordanMSWebApp/refs/heads/configure-terraform/terraform/azure/install-iis.ps1"],
    "commandToExecute": "powershell -ExecutionPolicy Unrestricted -File install-iis.ps1"
}
SETTINGS
}