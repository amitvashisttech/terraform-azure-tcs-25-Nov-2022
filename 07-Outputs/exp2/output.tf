output "my_rg_names" { 
  value =  azurerm_resource_group.example.*.name
}


output "my_rg_name_first" { 
  value =  azurerm_resource_group.example.0.name
}

output "my_rg_ids" { 
  value =  azurerm_resource_group.example.*.id
}
