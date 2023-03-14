# Variaveis configuradas para substituição no pipeline do gihub action 

terraform {
  backend "azurerm" {
    storage_account_name = "{{ secrets.AZ_STG_NAME }}"
    container_name       = "{{ secrets.AZ_CONTAINER_NAME }}"
    key                  = "gihub_actions_test.tfstate"
    resource_group_name  = "rg-poc-terraform-eastus"
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