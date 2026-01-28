terraform {
    required_version = ">= 1.0"

    required_providers {
      azurerm = {
        source = "hashicorp/azurerm"
        version = ">= 3.0"
      }
      random = {
        source = "hashicorp/random"
        version = ">= 3.0"
      }
    }

    backend "azurerm" {
        resource_group_name = "rg_terraform_resources"
        storage_account_name = "tfstatednrenv"
        container_name = "webdesbloq-prod"
        key = "prod.terraform.tfstate"
    }
}

provider "azurerm" {
    features {}
    subscription_id = "bf1b23d5-27c7-4861-af00-910e48a03bce"
}