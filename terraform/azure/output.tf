output "vm-public-ip" {
    description = "This is the public ip of the vm."
    value = azurerm_windows_virtual_machine.vm.public_ip_address
}