# Variaveis configuradas para substituição no pipeline do gihub action 

terraform {
  backend "azurerm" {
    resource_group_name  = "rg-poc-terraform-eastus"
    storage_account_name = "sapoctflogicalis"
    container_name       = "terraform-tfstate"
    key                  = "gihub_actions_test.tfstate"
  }
}

# terraform {
#   backend "local" {}
#   required_providers {
#     azurerm = {
#       source  = "hashicorp/azurerm"
#       version = "3.46.0"
#     }
#   }
# }