# Create a resource group
resource "azurerm_resource_group" "example" {
  name     = "${var.my_rg_name}-${count.index}"
  location = var.my_loc[count.index]
  count    = 2 

  tags = { 
   Owner = "Amit Vashist"
   Team  = "DevOps Team" 
   Project = "Terraform Automation" 

  }

}
