resource "azurerm_resource_group" "rg" {
    name     = "${var.application}-rg"
    location = var.location
}