# Create a resource group
resource "azurerm_resource_group" "example_rg" {
  name     = var.my_rg_name
  location = var.my_loc
 
  tags = {
    Owner = "AV"
   }
}
