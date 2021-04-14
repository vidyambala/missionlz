terraform {
  required_providers {
    databricks = {
      source = "databrickslabs/databricks"
      version = "0.3.1"
    }
  }
}

data "azurerm_client_config" "current" {}

provider "databricks" {
  azure_workspace_resource_id = var.azure_databricks_workspace_id
  azure_client_id             = var.client_id
  azure_client_secret         = var.client_secret
  azure_tenant_id             = var.tenant_id
}

resource "databricks_group" "admin_group" {
  display_name = "ws_dmin"
  allow_cluster_create = true
  allow_instance_pool_create = true
}

resource "databricks_group" "data_analyst" {
  display_name = "data_analyst"
  allow_cluster_create = false
  allow_instance_pool_create = false
}


