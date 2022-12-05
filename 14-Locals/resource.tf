variable "project-name" { 
 default = "terraform-demo"
}


locals { 
  default_name = "${join("-", tolist([var.project-name, "RG"]))}" 
}


locals { 
  some_tags = { 
    Owner = "DevOps Team"
    Project = "Terraform Automation" 
    Env    =  "Production"
    Name   = local.default_name
  }
}





resource "azurerm_resource_group" "blue" { 
   name = "${local.default_name}-blue" 
   location = "eastus" 
   tags = local.some_tags
}



resource "azurerm_resource_group" "green" { 
   #name = "${var.project-name}-green" 
   name = "${local.default_name}-green" 
   location = "eastus" 
   tags = local.some_tags
}



resource "azurerm_resource_group" "red" { 
   #name = "${var.project-name}-red" 
   name = "${local.default_name}-red" 
   location = "eastus" 
   tags = local.some_tags
}
