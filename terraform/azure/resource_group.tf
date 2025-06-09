resource "azurerm_resource_group" "rg" {
    name     = "${var.application}-${var.environment}-rg"
    location = var.location
}