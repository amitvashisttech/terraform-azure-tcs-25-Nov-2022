# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
}


# Create a resource group
resource "azurerm_resource_group" "example" {
  count = 1 
  name     = "Orange-RG-${count.index}"
  location = "eastus"

  lifecycle { 
     create_before_destroy = true 
  }

}
