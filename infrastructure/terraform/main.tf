# ECAP Terraform Configuration

terraform {
  required_version = ">= 1.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }

  backend "azurerm" {
    # Configure remote state storage
    # resource_group_name  = "ecap-terraform-state"
    # storage_account_name = "ecapterraformstate"
    # container_name       = "tfstate"
    # key                  = "production.terraform.tfstate"
  }
}

provider "azurerm" {
  features {}
}
