output "azure_databricks_workspace_id" {
  description 			= "Value of Databricks workspace Id, to be used in cluster module"
  value       			= azurerm_databricks_workspace.databricks-ws.id
}

