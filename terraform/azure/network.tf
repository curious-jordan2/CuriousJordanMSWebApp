resource "azurerm_virtual_network" "vnet" {
	name                = "${var.application}-vnet"
	address_space       = ["10.0.0.0/16"]
	location            = var.location
	resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_public_ip" "public_ip" {
    name                = "${var.application}-ip"
    location            = var.location
    resource_group_name = azurerm_resource_group.rg.name
    allocation_method   = "Dynamic"
}

resource "azurerm_network_security_group" "nsg" {
    name                = "${var.application}-nsg"
    location            = var.location
    resource_group_name = azurerm_resource_group.rg.name
    
    security_rule {
        name                       = "allow_http"
        priority                   = 1001
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "80"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
    }

    security_rule {
        name                       = "allow_rdp"
        priority                   = 1002
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "3389"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
    }
    
}

resource "azurerm_network_interface" "nic" {
    name                = "${var.application}-nic"
    location            = var.location
    resource_group_name = azurerm_resource_group.rg.name

    ip_configuration {
        name                          = "internal"
        subnet_id                     = azurerm_subnet.subnet.id
        private_ip_address_allocation = "Dynamic"
        public_ip_address_id          = azurerm_public_ip.public_ip.id
    }
}