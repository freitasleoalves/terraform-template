terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "2.88.1"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "2.15.0"
    }
    null = {
      source  = "hashicorp/null"
      version = "3.1.0"
    }
  }
  # backend "azurerm" {}
}
