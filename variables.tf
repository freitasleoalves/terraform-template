variable "subscription_id" {
  type = object({
    connectivity  = string
    management    = string
    identity      = string
    cliente360    = string
    core_security = string
  })
  sensitive = true
}

variable "connectivity" {
  description = "Variables for connectivity module"
  type = object({
    location                       = string
    vnet_address_space             = list(string)
    snet_gateway_address_prefixes  = list(string)
    snet_firewall_address_prefixes = list(string)
    snet_bastion_address_prefixes  = list(string)
    snet_api_address_prefixes      = list(string)
  })
  default = {
    location                       = "brazilsouth"
    vnet_address_space             = ["10.120.0.0/23"]
    snet_gateway_address_prefixes  = ["10.120.0.0/27"]
    snet_firewall_address_prefixes = ["10.120.0.64/26"]
    snet_bastion_address_prefixes  = ["10.120.0.128/26"]
    snet_api_address_prefixes      = ["10.120.0.192/26"]
  }
}

variable "management" {
  description = "Variables for management module"
  type = object({
    location              = string
    vnet_address_space    = list(string)
    snet_address_prefixes = list(string)
    vms = list(object({
      name               = string
      size               = string
      os_type            = string
      admin_username     = string
      admin_password     = string
      private_ip_address = string
    }))
  })
  default = {
    location              = "brazilsouth"
    vnet_address_space    = ["10.120.4.0/23"]
    snet_address_prefixes = ["10.120.4.0/24"]
    vms = [
      {
        name               = "AZU-0001-MGTBRA"
        size               = "Standard_B2ms"
        os_type            = "windows"
        admin_username     = "adminuser"
        admin_password     = "P@$$w0rd1234!"
        private_ip_address = "10.120.4.4"
      }
    ]
  }
}

variable "identity" {
  description = "Variables for identity module"
  type = object({
    location           = string
    vnet_address_space = list(string)
    env_configs = map(object({
      env              = string
      suffix           = string
      address_prefixes = list(string)
    }))
  })
  default = {
    location           = "brazilsouth"
    vnet_address_space = ["10.120.2.0/23"]
    env_configs = {
      "identity" = {
        env              = ""
        suffix           = ""
        address_prefixes = ["10.120.2.0/24"]
      },
      "prd_umbrella" = {
        env              = "prd"
        suffix           = "umbrella"
        address_prefixes = ["10.120.3.0/28"]
      },
      "hom_umbrella" = {
        env              = "hom"
        suffix           = "umbrella"
        address_prefixes = ["10.120.3.16/28"]
      }
    }
  }
}

variable "cliente360" {
  description = "Variables for cliente360 module"
  type = object({
    location           = string
    vnet_address_space = list(string)
    env_configs = map(object({
      env              = string
      suffix           = string
      address_prefixes = list(string)
    }))
  })
  default = {
    location           = "eastus"
    vnet_address_space = ["10.120.8.0/21"]
    env_configs = {
      "prd_aks" = {
        env              = "prd"
        suffix           = "aks"
        address_prefixes = ["10.120.8.0/23"]
      },
      "prd_misc" = {
        env              = "prd"
        suffix           = "misc"
        address_prefixes = ["10.120.10.0/24"]
      },
      "prd_netapp" = {
        env              = "prd"
        suffix           = "netapp"
        address_prefixes = ["10.120.11.0/24"]
      },
      "dev_aks" = {
        env              = "dev"
        suffix           = "aks"
        address_prefixes = ["10.120.12.0/23"]
      },
      "dev_misc" = {
        env              = "dev"
        suffix           = "misc"
        address_prefixes = ["10.120.14.0/24"]
      },
      "dev_netapp" = {
        env              = "dev"
        suffix           = "netapp"
        address_prefixes = ["10.120.15.0/24"]
      }
    }
  }
}

variable "_360" {
  description = "Variables for 360 module"
  type = object({
    location           = string
    vnet_address_space = list(string)
    env_configs = map(object({
      env              = string
      suffix           = string
      address_prefixes = list(string)
    }))
    postgresql = list(object({
      env                    = string
      administrator_login    = string
      administrator_password = string
      sku_name               = string
      zone                   = string
      storage_mb             = number
      backup_retention_days  = number
    }))
  })
  default = {
    location           = "brazilsouth"
    vnet_address_space = ["10.120.16.0/21"]
    env_configs = {
      "green_aks" = {
        env              = "green"
        suffix           = "aks"
        address_prefixes = ["10.120.16.0/23"]
      },
      "green_misc" = {
        env              = "green"
        suffix           = "misc"
        address_prefixes = ["10.120.18.0/26"]
      },
      "green_netapp" = {
        env              = "green"
        suffix           = "netapp"
        address_prefixes = ["10.120.19.0/26"]
      },
      "green_db" = {
        env              = "green"
        suffix           = "db"
        address_prefixes = ["10.120.23.144/28"]
      },
      "blue_aks" = {
        env              = "blue"
        suffix           = "aks"
        address_prefixes = ["10.120.20.0/23"]
      },
      "blue_misc" = {
        env              = "blue"
        suffix           = "misc"
        address_prefixes = ["10.120.22.0/26"]
      },
      "blue_netapp" = {
        env              = "blue"
        suffix           = "netapp"
        address_prefixes = ["10.120.23.0/26"]
      },
      "blue_db" = {
        env              = "blue"
        suffix           = "db"
        address_prefixes = ["10.120.23.128/28"]
      },
      "front" = {
        env              = "front"
        suffix           = ""
        address_prefixes = ["10.120.23.64/27"]
      },
      "shared" = {
        env              = "shared"
        suffix           = ""
        address_prefixes = ["10.120.23.96/27"]
      }
    },
    postgresql = [
      {
        env                    = "green"
        administrator_login    = "pgsqlgreen360bsouthadmin"
        administrator_password = "HpKF%%kBVMUY8*aHBf7#9pPu@HNrRPa8"
        sku_name               = "GP_Standard_D4s_v3"
        zone                   = "1"
        storage_mb             = 262144
        backup_retention_days  = 31
      },
      {
        env                    = "blue"
        administrator_login    = "pgsqlblue360bsouthadmin"
        administrator_password = "F^t4$G7Rf$iRS&LqXs#pWznji2DJnt5t"
        sku_name               = "GP_Standard_D4s_v3"
        zone                   = "2"
        storage_mb             = 262144
        backup_retention_days  = 31
      }
    ]
  }
}

variable "cyber" {
  description = "Variables for cyber module"
  type = object({
    location              = string
    vnet_address_space    = list(string)
    snet_address_prefixes = list(string)
    vms = list(object({
      name               = string
      size               = string
      os_type            = string
      admin_username     = string
      admin_password     = string
      private_ip_address = string
    }))
  })
  default = {
    location              = "brazilsouth"
    vnet_address_space    = ["10.120.24.0/24"]
    snet_address_prefixes = ["10.120.24.0/24"]
    vms = [
      {
        name               = "IRWAZURE01"
        size               = "Standard_DS2_v2"
        os_type            = "windows"
        admin_username     = "adminuser"
        admin_password     = "P@$$w0rd1234!"
        private_ip_address = "10.120.24.10"
      }
    ]
  }
}

variable "oiid" {
  description = "Variables for oiid module"
  type = object({
    location              = string
    vnet_address_space    = list(string)
    snet_address_prefixes = list(string)
  })
  default = {
    location              = "brazilsouth"
    vnet_address_space    = ["10.120.26.0/23"]
    snet_address_prefixes = ["10.120.27.0/28"]
  }
}

variable "authorized_ips" {
  description = "All IPs are blocked by default, use this list to authorized desired IPs for administration purposes"
  type        = list(string)
  sensitive   = true
}

variable "user_principal_name" {
  description = "User for Azure Active Directory groups owner, used as workaround for bug in azuread"
  type        = string
  sensitive   = true
}

variable "rbac_groups" {
  description = "List of groups to be created in Azure Active Directory"
  type        = list(string)
  default = [
    "Azure Cliente360 owners",
    "Azure Cliente360 contributors",
    "Azure Cliente360 readers"
  ]
}
