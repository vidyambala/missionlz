# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

terraform {
  backend "azurerm" {}
}

provider "azurerm" {
  environment     		= var.tf_environment
  metadata_host   		= var.mlz_metadatahost
  tenant_id       		= var.mlz_tenantid
  subscription_id	 	= var.databricks_subid
  client_id       		= var.mlz_clientid
  client_secret   		= var.mlz_clientsecret

  features {}
}

provider "azurerm" {
  alias           		= "hub"
  environment     		= var.tf_environment
  metadata_host   		= var.mlz_metadatahost
  tenant_id       		= var.mlz_tenantid
  subscription_id 		= var.saca_subid
  client_id       		= var.mlz_clientid
  client_secret   		= var.mlz_clientsecret

  features {}
}

provider "random" {
}

data "azurerm_resource_group" "hub" {
  provider 			= azurerm.hub
  name     			= var.saca_rgname
}

data "azurerm_virtual_network" "hub" {
  provider            		= azurerm.hub
  name                		= var.saca_vnetname
  resource_group_name 		= data.azurerm_resource_group.hub.name
}

data "azurerm_log_analytics_workspace" "hub" {
  provider            		= azurerm.hub
  name                		= var.saca_lawsname
  resource_group_name 		= data.azurerm_resource_group.hub.name
}

data "azurerm_firewall" "firewall" {
  provider            		= azurerm.hub
  name                		= var.saca_fwname
  resource_group_name 		= data.azurerm_resource_group.hub.name
}

resource "azurerm_resource_group" "databricks_rg" {
  name                		= var.databricks_rgname
  location            		= var.mlz_location
  tags                		= var.tags
}


module "network" {
  depends_on                 	= [azurerm_resource_group.databricks_rg, data.azurerm_log_analytics_workspace.hub]
  source                     	= "../../../modules/virtual-network"
  location                   	= azurerm_resource_group.databricks_rg.location
  resource_group_name        	= azurerm_resource_group.databricks_rg.name
  vnet_name                  	= var.databricks_vnetname
  vnet_address_space         	= var.databricks_vnet_address_space
  log_analytics_workspace_id 	= data.azurerm_log_analytics_workspace.hub.id

  tags = {
    DeploymentName 		= var.deploymentname
  }
}

module "subnets" {
  depends_on 			= [module.network]
  source     			= "../../../modules/databricks/workspace/subnets"
  resource_group_name 		= module.network.resource_group_name
  virtual_network_name          = module.network.virtual_network_name
  private_address_prefixes 	= var.private_address_prefixes
  public_address_prefixes 	= var.public_address_prefixes
  }

module "nsg" {
  depends_on                    = [module.subnets]
  source                        = "../../../modules/databricks/workspace/nsg"
  name_prefix                   = var.name_prefix
  location                  	= azurerm_resource_group.databricks_rg.location
  databricks_resource_group_name= module.network.resource_group_name
  private_subnet_name           = module.subnets.private_subnet_name
  public_subnet_name            = module.subnets.public_subnet_name
  private_subnet_id             = module.subnets.private_subnet_id
  public_subnet_id              = module.subnets.public_subnet_id
  routetable_name    		= var.routetable_name
  firewall_ip_address 		= data.azurerm_firewall.firewall.ip_configuration[0].private_ip_address
  log_analytics_storage_id   	= module.network.log_analytics_storage_id
  log_analytics_workspace_id 	= data.azurerm_log_analytics_workspace.hub.id
  tags                          = var.tags
}

module "workspace" {
  depends_on                    = [module.nsg]
  source                        = "../../../modules/databricks/workspace/workspace"
  name_prefix                   = var.name_prefix
  location                      = azurerm_resource_group.databricks_rg.location
  databricks_resource_group_name= module.network.resource_group_name
  virtual_network_id            = module.network.virtual_network_id
  private_subnet_name           = module.subnets.private_subnet_name
  public_subnet_name            = module.subnets.public_subnet_name
}

