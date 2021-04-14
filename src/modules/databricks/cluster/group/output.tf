output "databricks_data_analyst_group_id" {
  description = "Databricks group Id"
  value       = databricks_group.data_analyst.id
}


output "databricks_admin_group_id" {
  description = "Databricks Admin group Id"
  value       =  databricks_group.admin_group.id
}
