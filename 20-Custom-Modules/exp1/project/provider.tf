# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
}


provider "aws" {
  # access_key = "XXXXXXX" 
  # secret_key = "YYYYYYY"
  region = "us-east-2"
}

