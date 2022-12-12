# Create a Resource Group
resource "azurerm_resource_group" "blue" {
  count    = 2 
  name     = "terraform-remotetest-RG-${count.index +1}"
  location = "eastus"
  tags = {
    Owner = "T" 
    Team  = "A Team"
    Project = "Terraform Automation"
  }
}
