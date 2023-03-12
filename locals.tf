locals {
  vnets = [
    {
      id            = module.connectivity.vnet.id
      name          = module.connectivity.vnet.name
      address_space = var.connectivity.vnet_address_space[0]
    },
    {
      id            = module.management.vnet.id
      name          = module.management.vnet.name
      address_space = var.management.vnet_address_space[0]
    },
    {
      id            = module.identity.vnet.id
      name          = module.identity.vnet.name
      address_space = var.identity.vnet_address_space[0]
    },
    {
      id            = module.cliente360.vnet.id
      name          = module.cliente360.vnet.name
      address_space = var.cliente360.vnet_address_space[0]
    },
    {
      id            = module._360.vnet.id
      name          = module._360.vnet.name
      address_space = var._360.vnet_address_space[0]
    },
    {
      id            = module.cyber.vnet.id
      name          = module.cyber.vnet.name
      address_space = var.cyber.vnet_address_space[0]
    },
    {
      id            = module.oiid.vnet.id
      name          = module.oiid.vnet.name
      address_space = var.oiid.vnet_address_space[0]
    }
  ]
}
