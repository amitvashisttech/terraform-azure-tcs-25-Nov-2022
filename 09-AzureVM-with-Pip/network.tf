# Create a resource group
resource "azurerm_resource_group" "example_rg" {
  name     = "example-resources-RG"
  location = "eastus"

 tags = { 
    Owner = "AV"
  
  }
}

# Create a virtual network within the resource group
resource "azurerm_virtual_network" "example_rg" {
  name                = "example-network"
  resource_group_name = azurerm_resource_group.example_rg.name
  location            = azurerm_resource_group.example_rg.location
  address_space       = ["10.0.0.0/16"]
}


## Azure Subnets

## Internal 
resource "azurerm_subnet" "internal" {
  name                 = "internal-subnet"
  resource_group_name  = azurerm_resource_group.example_rg.name
  virtual_network_name = azurerm_virtual_network.example_rg.name
  address_prefixes     = ["10.0.1.0/24"]
}



## External 
resource "azurerm_subnet" "external" {
  name                 = "external-subnet"
  resource_group_name  = azurerm_resource_group.example_rg.name
  virtual_network_name = azurerm_virtual_network.example_rg.name
  address_prefixes     = ["10.0.7.0/24"]
}


## Network Interface 
resource "azurerm_network_interface" "example_rg" {
  name                = "example-nic"
  location            = azurerm_resource_group.example_rg.location
  resource_group_name = azurerm_resource_group.example_rg.name

  ip_configuration {
    name                          = "testconfig1"
    subnet_id                     = azurerm_subnet.internal.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.examplepublicip.id 
  }
}

# Public IP Configuration 
resource "azurerm_public_ip" "examplepublicip" {
    name                         = "myPublicIP"
    location                     = "eastus"
    resource_group_name          = azurerm_resource_group.example_rg.name
    allocation_method            = "Dynamic"
}


# Create Network Security Group and rule
resource "azurerm_network_security_group" "examplensg" {
    name                = "myNetworkSecurityGroup"
    location            = "eastus"
    resource_group_name = azurerm_resource_group.example_rg.name

    security_rule {
        name                       = "SSH"
        priority                   = 1001
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "22"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
    }
}




