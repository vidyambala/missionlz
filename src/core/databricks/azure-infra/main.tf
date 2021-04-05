# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.
terraform {
  backend "azurerm" {}
}

provider "azurerm" {
  version         = "~> 2.50.0"
  environment     = var.tf_environment
  metadata_host   = var.mlz_metadatahost
  tenant_id       = var.mlz_tenantid
  subscription_id = var.databricks_subid
  client_id       = var.mlz_clientid
  client_secret   = var.mlz_clientsecret

  features {}
}

provider "azurerm" {
  version         = "~> 2.50.0"
  alias           = "hub"
  environment     = var.tf_environment
  metadata_host   = var.mlz_metadatahost
  tenant_id       = var.mlz_tenantid
  subscription_id = var.saca_subid
  client_id       = var.mlz_clientid
  client_secret   = var.mlz_clientsecret

  features {}
}

provider "random" {
  version = "3.1.0"
}

data "azurerm_resource_group" "hub" {
  provider = azurerm.hub
  name     = var.saca_rgname
}

data "azurerm_virtual_network" "hub" {
  provider            = azurerm.hub
  name                = var.saca_vnetname
  resource_group_name = data.azurerm_resource_group.hub.name
}

data "azurerm_log_analytics_workspace" "hub" {
  provider            = azurerm.hub
  name                = var.saca_lawsname
  resource_group_name = data.azurerm_resource_group.hub.name
}

data "azurerm_firewall" "firewall" {
  provider            = azurerm.hub
  name                = var.saca_fwname
  resource_group_name = data.azurerm_resource_group.hub.name
}

resource "azurerm_resource_group" "databricks_rg" {
  name                = var.databricks_rgname
  location            = var.mlz_location
  tags                = var.tags
}


module "databricks-network" {
  depends_on                 = [azurerm_resource_group.databricks_rg, data.azurerm_log_analytics_workspace.hub]
  source                     = "../../../modules/virtual-network"
  location                   = azurerm_resource_group.databricks_rg.location
  resource_group_name        = azurerm_resource_group.databricks_rg.name
  vnet_name                  = var.databricks_vnetname
  vnet_address_space         = var.databricks_vnet_address_space
  log_analytics_workspace_id = data.azurerm_log_analytics_workspace.hub.id

  tags = {
    DeploymentName = var.deploymentname
  }
}

module "databricks-subnets" {
  depends_on = [module.databricks-network, data.azurerm_log_analytics_workspace.hub]
  source     = "../../../modules/subnet"
  for_each   = var.subnets

  name                 = each.value.name
  location             = var.mlz_location
  resource_group_name  = module.databricks-network.resource_group_name
  virtual_network_name = module.databricks-network.virtual_network_name
  address_prefixes     = each.value.address_prefixes
  service_endpoints    = lookup(each.value, "service_endpoints", [])

  enforce_private_link_endpoint_network_policies = lookup(each.value, "enforce_private_link_endpoint_network_policies", null)
  enforce_private_link_service_network_policies  = lookup(each.value, "enforce_private_link_service_network_policies", null)

  nsg_name  = each.value.nsg_name
  nsg_rules = each.value.nsg_rules

  routetable_name     = each.value.routetable_name
  firewall_ip_address = data.azurerm_firewall.firewall.ip_configuration[0].private_ip_address

  log_analytics_storage_id   = module.databricks-network.log_analytics_storage_id
  log_analytics_workspace_id = data.azurerm_log_analytics_workspace.hub.id

  tags = {
    DeploymentName = var.deploymentname
  }
}

module "databricks-outbound-peering" {
  source				= "../../../modules/virtual-network-outbound-peering"

  source_rg_name              		= module.databricks-network.resource_group_name
  source_vnet_name            		= module.databricks-network.virtual_network_name
  destination_vnet_name       		= data.azurerm_virtual_network.hub.name
  destination_rg_name         		= data.azurerm_resource_group.hub.name
  destination_subscription_id 		= var.saca_subid

  tags = {
    DeploymentName = var.deploymentname
  }
}

module "databricks-workspace" {
  depends_on				= [module.databricks-network, module.databricks-subnets]
  source                    		= "../../../modules/databricks/azure-infra/databricks-workspace"

  name_prefix               		= var.name_prefix
  mlz_location                          = var.mlz_location
  databricks_resource_group_name        = module.databricks-network.resource_group_name
  virtual_network_id                    = module.databricks-network.virtual_network_id
  private_subnet_name                   = module.databricks-subnets.private_subnet_name
  public_subnet_name                    = module.databricks-subnets.private_subnet_name
}
