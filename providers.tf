provider "azurerm" {
  subscription_id = var.subscription_id.connectivity
  features {
    key_vault {
      purge_soft_delete_on_destroy    = false
      recover_soft_deleted_key_vaults = true
    }
  }
}

provider "azurerm" {
  alias = "identity"
  subscription_id = var.subscription_id.identity
  features {
    key_vault {
      purge_soft_delete_on_destroy    = false
      recover_soft_deleted_key_vaults = true
    }
  }
}

provider "azurerm" {
  alias = "management"
  subscription_id = var.subscription_id.management
  features {
    key_vault {
      purge_soft_delete_on_destroy    = false
      recover_soft_deleted_key_vaults = true
    }
  }
}

provider "azurerm" {
  alias = "cliente360"
  subscription_id = var.subscription_id.cliente360
  features {
    key_vault {
      purge_soft_delete_on_destroy    = false
      recover_soft_deleted_key_vaults = true
    }
  }
}

provider "azurerm" {
  alias = "core_security"
  subscription_id = var.subscription_id.core_security
  features {
    key_vault {
      purge_soft_delete_on_destroy    = false
      recover_soft_deleted_key_vaults = true
    }
  }
}
