# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
}


# Create a resource group
resource "azurerm_resource_group" "example" {
  name     = "Blue-RG"
  location = "eastus"

  tags = {
    Owner   = "Amit Vashist"
    Team    = "DevOps"
    Project = "TF Automation"
  }

}



# Create a resource group
resource "azurerm_resource_group" "green" {
  name     = "Green-RG"
  location = "eastus"

  tags = {
    Owner   = "Amit Vashist"
    Team    = "DevOps"
    Project = "TF Automation"
  }

}
