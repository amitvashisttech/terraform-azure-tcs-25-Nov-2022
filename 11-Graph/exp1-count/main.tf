# Create a resource group
resource "azurerm_resource_group" "example" {
  count = 5 
  name     = "Blue-RG-${count.index}"
  location = "eastus"
}

# Create a resource group
resource "azurerm_resource_group" "green" {
  name     = "Green-RG-AV"
  location = "eastus"
}

# AWS Instance 
resource "aws_instance" "web" {
  ami           = "ami-08b6f2a5c291246a0"
  instance_type = "t2.micro"

  tags = {
    Name = "HelloWorld-Test-AV"
  }
}
