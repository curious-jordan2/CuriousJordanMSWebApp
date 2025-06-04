# Define the Azure Resource Group
resource "azurerm_resource_group" "rg" {
    name = "${var.vm_name}-rg"
    location = "East US"
}