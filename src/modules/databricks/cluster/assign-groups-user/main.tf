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

resource "databricks_group_member" "assign_admin_role" {
  group_id =  var.databricks_admin_group_id
  for_each      = var.databricks_admin_user_id
  member_id =  each.value
}

resource "databricks_group_member" "assign_data_analyst_role" {
  group_id =  var.databricks_data_analyst_group_id
  for_each      = var.databricks_data_analyst_user_id
  member_id =  each.value
}

