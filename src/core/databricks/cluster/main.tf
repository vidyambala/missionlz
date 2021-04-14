# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

terraform {
  backend "azurerm" {}
}

provider "azurerm" {
  environment                   = var.tf_environment
  metadata_host                 = var.mlz_metadatahost
  tenant_id                     = var.mlz_tenantid
  subscription_id               = var.databricks_subid
  client_id                     = var.mlz_clientid
  client_secret                 = var.mlz_clientsecret

  features {}
}

module "cluster" {
  source                                                = "../../../modules/databricks/cluster/cluster"
  name_prefix                                           = var.name_prefix
  databricks_resource_group_name = var.databricks_rgname
  client_id						= var.mlz_clientid
  client_secret						= var.mlz_clientsecret
  tenant_id						= var.mlz_tenantid
}

module "group" {
  source                                                = "../../../modules/databricks/cluster/group"
  azure_databricks_workspace_id                         = module.cluster.azure_databricks_workspace_id
  client_id                                             = var.mlz_clientid
  client_secret                                         = var.mlz_clientsecret
  tenant_id                                             = var.mlz_tenantid
}

module "user" {
  source                                                = "../../../modules/databricks/cluster/user"
  azure_databricks_workspace_id                         = module.cluster.azure_databricks_workspace_id
  client_id                                             = var.mlz_clientid
  client_secret                                         = var.mlz_clientsecret
  tenant_id                                             = var.mlz_tenantid
}

module "assign-groups-user" {
  source                                                = "../../../modules/databricks/cluster/assign-groups-user"
  azure_databricks_workspace_id                         = module.cluster.azure_databricks_workspace_id
  client_id                                             = var.mlz_clientid
  client_secret                                         = var.mlz_clientsecret
  tenant_id                                             = var.mlz_tenantid
  databricks_data_analyst_user_id			= module.user.databricks_data_analyst_user_id
  databricks_admin_user_id				= module.user.databricks_admin_user_id
  databricks_data_analyst_group_id                      = module.group.databricks_data_analyst_group_id
  databricks_admin_group_id                             = module.group.databricks_admin_group_id
}
