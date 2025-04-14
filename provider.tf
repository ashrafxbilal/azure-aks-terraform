# Define required providers and versions
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.12.0"
    }
    azuread = {
      source = "hashicorp/azuread"
      version = "~> 3.0.2"
    }
    tls = {
      source  = "hashicorp/tls"
    }
  }

  required_version = ">= 1.9.0"
}

# configure providers
provider "azurerm" {
  features {
    key_vault {
      purge_soft_delete_on_destroy = false
    }
  }
}

provider "azuread" {
  
}
