terraform {
  required_providers {
    databricks = {
      source = "databrickslabs/databricks"
      version = "0.3.1"
    }
  }
}

data "azurerm_client_config" "current" {}

data "azurerm_databricks_workspace" "workspace" {
  name                = "${var.name_prefix}-db-ws"
  resource_group_name = var.databricks_resource_group_name
}

provider "databricks" {
  azure_workspace_resource_id = data.azurerm_databricks_workspace.workspace.id
  azure_client_id             = var.client_id
  azure_client_secret         = var.client_secret
  azure_tenant_id             = var.tenant_id
}

data "databricks_node_type" "smallest" {
  local_disk = true
}

data "databricks_spark_version" "latest_lts" {
  long_term_support = true
}

resource "databricks_cluster" "dbcluster" {
  cluster_name            =  "${var.name_prefix}-databricks-cluster"
  spark_version           = data.databricks_spark_version.latest_lts.id
  node_type_id            = data.databricks_node_type.smallest.id
  autotermination_minutes = var.auto_terminate
  autoscale {
    min_workers = var.min_workers 
    max_workers = var.max_workers
  }
  spark_conf  =  {
     "spark.databricks.passthrough.enabled" : var.aad_adlsgen2_passthru
  }
}
