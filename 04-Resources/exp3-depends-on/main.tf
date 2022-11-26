# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
}


# Create a resource group
resource "azurerm_resource_group" "front" {
  count = 1 
  name     = "frontend-RG-${count.index}"
  location = "eastus"
  depends_on = [ azurerm_resource_group.back ]
}




# Create a resource group
resource "azurerm_resource_group" "back" {
  count = 1 
  name     = "backend-RG-${count.index}"
  location = "eastus"
}
