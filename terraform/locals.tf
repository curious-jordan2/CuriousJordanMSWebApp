# Defines resusable expressions (name prefixes, tags)
locals {
    storage_account_name = "storage${random_string.unique.result}"
    nic_name = "${var.vm_name}Nic"
    address_prefix = "10.0.0.0/16"
    subnet_name = "Subnet"
    subnet_prefix = "10.0.0.0./24"
    public_ip_address_name = "${var.vm_name}PublicIp"
    virtual_network_name = "${var.vm_name}VNET"
    network_security_group_name = "${var.vm_name}NSG"
}