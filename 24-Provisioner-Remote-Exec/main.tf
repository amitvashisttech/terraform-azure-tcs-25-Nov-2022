provider "azurerm" {
  features {}
}

# Resource Group Creation 
resource "azurerm_resource_group" "rg" {
  name = "red-rg"
  location = "eastus"
}

# Create a virtual network
resource "azurerm_virtual_network" "vnet" {
    name                = "myVnet"
    address_space       = ["10.0.0.0/16"]
    location            = "eastus"
    resource_group_name = azurerm_resource_group.rg.name
}

# Create a Subnet
resource "azurerm_subnet" "myterraformsubnet" {
    name                 = "mySubnet"
    resource_group_name  = azurerm_resource_group.rg.name
    virtual_network_name = azurerm_virtual_network.vnet.name
    address_prefixes       = ["10.0.2.0/24"]
}

# Create public IP address
resource "azurerm_public_ip" "myterraformpublicip" {
    name                         = "myPublicIP"
    location                     = "eastus"
    resource_group_name          = azurerm_resource_group.rg.name
    allocation_method            = "Dynamic"

    tags = {
        environment = "Terraform Demo"
    }
}


# Create Network Security Group
resource "azurerm_network_security_group" "myterraformnsg" {
    name                = "myNetworkSecurityGroup"
    location            = "eastus"
    resource_group_name = azurerm_resource_group.rg.name

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
   security_rule {
      name                       = "http"
      priority                   = 1005
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "80"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    }
   security_rule {
      name                       = "https"
      priority                   = 1006
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "443"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    }

    tags = {
        environment = "Terraform Demo"
    }
}


# Create network interface
resource "azurerm_network_interface" "myterraformnic" {
    name                      = "myNIC"
    location                  = "eastus"
    resource_group_name       = azurerm_resource_group.rg.name

    ip_configuration {
        name                          = "myNicConfiguration"
        subnet_id                     = azurerm_subnet.myterraformsubnet.id
        private_ip_address_allocation = "Dynamic"
        public_ip_address_id          = azurerm_public_ip.myterraformpublicip.id
    }

    tags = {
        environment = "Terraform Demo"
    }
}


# Connect the security group to the network interface
resource "azurerm_network_interface_security_group_association" "example" {
    network_interface_id      = azurerm_network_interface.myterraformnic.id
    network_security_group_id = azurerm_network_security_group.myterraformnsg.id
}





# Create (and display) an SSH key
resource "tls_private_key" "example_ssh" {
  algorithm = "RSA"
  rsa_bits = 4096
}


resource "local_file" "write_private_key" { 
    content = tls_private_key.example_ssh.private_key_pem 
    filename = "${path.root}/.terraform/.ssh/admin_rsa"
    file_permission = 0600
}


resource "local_file" "write_public_key" { 
    content = tls_private_key.example_ssh.public_key_openssh
    filename = "${path.root}/.terraform/.ssh/admin_rsa.pub"
    file_permission = 0600
}


output "tls_private_key" { 
    value = tls_private_key.example_ssh.private_key_pem 
    sensitive = true
}



# Create virtual machine
resource "azurerm_linux_virtual_machine" "myterraformvm" {
    #depends_on            = [local_file.write_public_key.filename]
    name                  = "myVM"
    location              = "eastus"
    resource_group_name   = azurerm_resource_group.rg.name
    network_interface_ids = [azurerm_network_interface.myterraformnic.id]
    size                  = "Standard_DS1_v2"

    os_disk {
        name              = "myOsDisk"
        caching           = "ReadWrite"
        storage_account_type = "Premium_LRS"
    }

    source_image_reference {
        publisher = "Canonical"
        offer     = "UbuntuServer"
        sku       = "16.04-LTS"
        version   = "latest"
    }



    computer_name  = "myvm"
    admin_username = "amitvashist"
    disable_password_authentication = true

    admin_ssh_key {
        username       = "amitvashist"
        public_key     = tls_private_key.example_ssh.public_key_openssh
    }


    tags = {
        environment = "Terraform Demo"
    }

  connection {
    timeout = "15m"
    type     = "ssh"
    user     = "amitvashist"
    private_key = tls_private_key.example_ssh.private_key_pem
    host     = self.public_ip_address
  }

provisioner "remote-exec" {
    inline = [
      "sudo apt-get update",
      "sudo apt-get install apache2 -y",
      "sudo service apache2 start",
      "sudo mkdir -p /var/www/html/Terraform-Images", 
      "sudo chmod 777 /var/www/html/Terraform-Images", 
      "sudo echo 'Hello World' >> /var/www/html/Terraform-Images/hello.html",
    ]

  }
   
}



output "my_public_ip" { 
  value = "${azurerm_linux_virtual_machine.myterraformvm.public_ip_address}"
}

