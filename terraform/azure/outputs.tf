# All outputs (Ip address, DNS label, etc)
output "hostname" {
    description = "The DNS name of the public IP"
    value = azurerm_public_ip.public_ip.fqdn
}

output "ip_address" {
    description = "The public IP address"
    value = azurerm_public_ip.public_ip.ip_address
}