output "azure_databricks_workspace_id" {
  description = "Databricks workspace Id in Azure management plane"
  value       = data.azurerm_databricks_workspace.workspace.id
}

