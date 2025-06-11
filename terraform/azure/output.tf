output "vm-public-ip" {
    description = "This is the public ip of the vm."
    value = azurerm_windows_virtual_machine.vm.public_ip_address
}

output "website-address" {
    description = "This is the website address for the application."
    value = "http://${azurerm_windows_virtual_machine.vm.public_ip_address}"
}