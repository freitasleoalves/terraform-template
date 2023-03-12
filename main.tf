/**
 * # Test markdown terraform-docs
 *
 * Everything in this comment block will get extracted.
 *
 * You can put simple text or complete Markdown content
 * here. Subsequently if you want to render AsciiDoc format
 * you can put AsciiDoc compatible content in this comment
 * block.
 */

###############################################################################
# Modules
###############################################################################
module "connectivity" {
  source                         = "./modules/CAF-Connectivity"
  location                       = var.connectivity.location
  vnet_address_space             = var.connectivity.vnet_address_space
  snet_gateway_address_prefixes  = var.connectivity.snet_gateway_address_prefixes
  snet_firewall_address_prefixes = var.connectivity.snet_firewall_address_prefixes
  snet_bastion_address_prefixes  = var.connectivity.snet_bastion_address_prefixes
  snet_api_address_prefixes      = var.connectivity.snet_api_address_prefixes

  vnets            = local.vnets
  log_analytics_id = module.management.log_analytics_id
}

module "management" {
  source                = "./modules/CAF-Management"
  location              = var.management.location
  vnet_address_space    = var.management.vnet_address_space
  snet_address_prefixes = var.management.snet_address_prefixes
  authorized_ips        = var.authorized_ips
  vms                   = var.management.vms

  vnets               = local.vnets
  firewall_private_ip = module.connectivity.firewall_private_ip

  providers = {
    azurerm = azurerm.management
  }
}

module "identity" {
  source             = "./modules/CAF-Identity"
  location           = var.identity.location
  vnet_address_space = var.identity.vnet_address_space
  env_configs        = var.identity.env_configs
  authorized_ips     = var.authorized_ips

  vnets               = local.vnets
  firewall_private_ip = module.connectivity.firewall_private_ip
  log_analytics_id    = module.management.log_analytics_id
  acr_cliente360      = module.cliente360.acr
  acr_360             = module._360.acr

  providers = {
    azurerm = azurerm.identity
  }
}

module "cliente360" {
  source             = "./modules/Cliente-360"
  location           = var.cliente360.location
  vnet_address_space = var.cliente360.vnet_address_space
  env_configs        = var.cliente360.env_configs
  authorized_ips     = var.authorized_ips

  vnets                = local.vnets
  firewall_private_ip  = module.connectivity.firewall_private_ip
  log_analytics_id     = module.management.log_analytics_id
  private_dns_zone_acr = module.identity.private_dns_zone_acr

  providers = {
    azurerm = azurerm.cliente360
  }
}

module "_360" {
  source             = "./modules/360"
  location           = var._360.location
  vnet_address_space = var._360.vnet_address_space
  env_configs        = var._360.env_configs
  postgresql         = var._360.postgresql
  authorized_ips     = var.authorized_ips

  vnets                       = local.vnets
  firewall_private_ip         = module.connectivity.firewall_private_ip
  log_analytics_id            = module.management.log_analytics_id
  private_dns_zone_acr        = module.identity.private_dns_zone_acr
  private_dns_zone_postgresql = module.identity.private_dns_zone_postgresql

  providers = {
    azurerm = azurerm.cliente360
  }
}

module "cyber" {
  source                = "./modules/Cyber"
  location              = var.cyber.location
  vnet_address_space    = var.cyber.vnet_address_space
  snet_address_prefixes = var.cyber.snet_address_prefixes
  authorized_ips        = var.authorized_ips
  vms                   = var.cyber.vms

  vnets               = local.vnets
  firewall_private_ip = module.connectivity.firewall_private_ip
  log_analytics_id    = module.management.log_analytics_id

  providers = {
    azurerm = azurerm.core_security
  }
}

module "oiid" {
  source                = "./modules/Oiid"
  location              = var.oiid.location
  vnet_address_space    = var.oiid.vnet_address_space
  snet_address_prefixes = var.oiid.snet_address_prefixes
  authorized_ips        = var.authorized_ips

  vnets               = local.vnets
  firewall_private_ip = module.connectivity.firewall_private_ip
  log_analytics_id    = module.management.log_analytics_id

  providers = {
    azurerm = azurerm.cliente360
  }
}

###############################################################################
# Role Based Access Control
###############################################################################
resource "azuread_group" "ad_group" {
  for_each         = toset(var.rbac_groups)
  display_name     = each.value
  description      = each.value
  owners           = [data.azuread_user.user.id]
  security_enabled = true

  lifecycle {
    ignore_changes = [
      owners,
      members
    ]
  }
}

###############################################################################
# Vnet Peerings
###############################################################################
resource "azurerm_virtual_network_peering" "connectivity-to-identity" {
  name                      = "${module.connectivity.vnet.name}-to-${module.identity.vnet.name}"
  resource_group_name       = module.connectivity.vnet.resource_group_name
  virtual_network_name      = module.connectivity.vnet.name
  remote_virtual_network_id = module.identity.vnet.id
  allow_gateway_transit     = true

  depends_on = [
    module.connectivity.virtual_network_gateway
  ]
}

resource "azurerm_virtual_network_peering" "identity-to-connectivity" {
  provider                  = azurerm.identity
  name                      = "${module.identity.vnet.name}-to-${module.connectivity.vnet.name}"
  resource_group_name       = module.identity.vnet.resource_group_name
  virtual_network_name      = module.identity.vnet.name
  remote_virtual_network_id = module.connectivity.vnet.id
  use_remote_gateways       = true

  depends_on = [
    module.connectivity.virtual_network_gateway,
    azurerm_virtual_network_peering.connectivity-to-identity
  ]
}

resource "azurerm_virtual_network_peering" "connectivity-to-management" {
  name                      = "${module.connectivity.vnet.name}-to-${module.management.vnet.name}"
  resource_group_name       = module.connectivity.vnet.resource_group_name
  virtual_network_name      = module.connectivity.vnet.name
  remote_virtual_network_id = module.management.vnet.id
  allow_gateway_transit     = true

  depends_on = [
    module.connectivity.virtual_network_gateway
  ]
}

resource "azurerm_virtual_network_peering" "management-to-connectivity" {
  provider                  = azurerm.management
  name                      = "${module.management.vnet.name}-to-${module.connectivity.vnet.name}"
  resource_group_name       = module.management.vnet.resource_group_name
  virtual_network_name      = module.management.vnet.name
  remote_virtual_network_id = module.connectivity.vnet.id
  use_remote_gateways       = true

  depends_on = [
    module.connectivity.virtual_network_gateway,
    azurerm_virtual_network_peering.connectivity-to-management
  ]
}

resource "azurerm_virtual_network_peering" "connectivity-to-cliente360" {
  name                      = "${module.connectivity.vnet.name}-to-${module.cliente360.vnet.name}"
  resource_group_name       = module.connectivity.vnet.resource_group_name
  virtual_network_name      = module.connectivity.vnet.name
  remote_virtual_network_id = module.cliente360.vnet.id
  allow_gateway_transit     = true

  depends_on = [
    module.connectivity.virtual_network_gateway
  ]
}

resource "azurerm_virtual_network_peering" "cliente360-to-connectivity" {
  provider                  = azurerm.cliente360
  name                      = "${module.cliente360.vnet.name}-to-${module.connectivity.vnet.name}"
  resource_group_name       = module.cliente360.vnet.resource_group_name
  virtual_network_name      = module.cliente360.vnet.name
  remote_virtual_network_id = module.connectivity.vnet.id
  use_remote_gateways       = true

  depends_on = [
    module.connectivity.virtual_network_gateway,
    azurerm_virtual_network_peering.connectivity-to-cliente360
  ]
}

resource "azurerm_virtual_network_peering" "connectivity-to-360" {
  name                      = "${module.connectivity.vnet.name}-to-${module._360.vnet.name}"
  resource_group_name       = module.connectivity.vnet.resource_group_name
  virtual_network_name      = module.connectivity.vnet.name
  remote_virtual_network_id = module._360.vnet.id
  allow_gateway_transit     = true

  depends_on = [
    module.connectivity.virtual_network_gateway
  ]
}

resource "azurerm_virtual_network_peering" "_360-to-connectivity" {
  provider                  = azurerm.cliente360
  name                      = "${module._360.vnet.name}-to-${module.connectivity.vnet.name}"
  resource_group_name       = module._360.vnet.resource_group_name
  virtual_network_name      = module._360.vnet.name
  remote_virtual_network_id = module.connectivity.vnet.id
  use_remote_gateways       = true

  depends_on = [
    module.connectivity.virtual_network_gateway,
    azurerm_virtual_network_peering.connectivity-to-360
  ]
}

resource "azurerm_virtual_network_peering" "connectivity-to-cyber" {
  name                      = "${module.connectivity.vnet.name}-to-${module.cyber.vnet.name}"
  resource_group_name       = module.connectivity.vnet.resource_group_name
  virtual_network_name      = module.connectivity.vnet.name
  remote_virtual_network_id = module.cyber.vnet.id
  allow_gateway_transit     = true

  depends_on = [
    module.connectivity.virtual_network_gateway
  ]
}

resource "azurerm_virtual_network_peering" "cyber-to-connectivity" {
  provider                  = azurerm.core_security
  name                      = "${module.cyber.vnet.name}-to-${module.connectivity.vnet.name}"
  resource_group_name       = module.cyber.vnet.resource_group_name
  virtual_network_name      = module.cyber.vnet.name
  remote_virtual_network_id = module.connectivity.vnet.id
  use_remote_gateways       = true

  depends_on = [
    module.connectivity.virtual_network_gateway,
    azurerm_virtual_network_peering.connectivity-to-cyber
  ]
}

resource "azurerm_virtual_network_peering" "connectivity-to-oiid" {
  name                      = "${module.connectivity.vnet.name}-to-${module.oiid.vnet.name}"
  resource_group_name       = module.connectivity.vnet.resource_group_name
  virtual_network_name      = module.connectivity.vnet.name
  remote_virtual_network_id = module.oiid.vnet.id
  allow_gateway_transit     = true

  depends_on = [
    module.connectivity.virtual_network_gateway
  ]
}

resource "azurerm_virtual_network_peering" "oiid-to-connectivity" {
  provider                  = azurerm.cliente360
  name                      = "${module.oiid.vnet.name}-to-${module.connectivity.vnet.name}"
  resource_group_name       = module.oiid.vnet.resource_group_name
  virtual_network_name      = module.oiid.vnet.name
  remote_virtual_network_id = module.connectivity.vnet.id
  use_remote_gateways       = true

  depends_on = [
    module.connectivity.virtual_network_gateway,
    azurerm_virtual_network_peering.connectivity-to-oiid
  ]
}
