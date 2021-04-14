output "databricks_data_analyst_user_id" {
  description = "Databricks user Id"
  value       =  {for key, uid in databricks_user.data_analyst_loop : key => uid.id}
}


output "databricks_admin_user_id" {
  description = "Databricks Admin user Id"
  value       =  {for key, uid in databricks_user.admin_loop : key => uid.id}
}


