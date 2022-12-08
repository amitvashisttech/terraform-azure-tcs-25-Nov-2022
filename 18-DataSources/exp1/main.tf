# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
}


# Create a resource group
resource "azurerm_resource_group" "frontend" {
  name     = "frontend-RG"
  location = "eastus"

  tags = { 
   Owner = "Amit Vashist" 
   Team = "DevOps"
   Project = "Terraform Automation"
 }
}


# Data Source 
data "azurerm_resource_group" "example" { 
  name = "frontend-RG"
  depends_on = [ azurerm_resource_group.frontend ]
}

output "resourcedetails" { 
  value = data.azurerm_resource_group.example
}




resource "azurerm_resource_group" "frontend-ext" {
  name     = "${data.azurerm_resource_group.example.name}-${count.index +1}"
  count    = 2 
  location = "eastus"

  tags = { 
   Owner = "Amit Vashist" 
   Team = "DevOps"
   Project = "Terraform Automation"
 }
}

