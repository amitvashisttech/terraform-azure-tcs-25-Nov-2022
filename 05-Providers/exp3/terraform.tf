terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      #version = "=2.97.0"
      version = ">=2.40, <=2.48"
    }

   
    aws = {
      source  = "hashicorp/aws"
      version = ">=3.40, <=3.65"
    }
  }
}

