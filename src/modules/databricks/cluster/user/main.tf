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

resource "databricks_user" "admin_loop" {
  for_each      = var.admin_list
  user_name    = each.value["email"]
  display_name  = each.value["name"]
}

resource "databricks_user" "data_analyst_loop" {
  for_each	= var.data_analyst_list
  user_name    = each.value["email"]
  display_name  = each.value["name"]
}
