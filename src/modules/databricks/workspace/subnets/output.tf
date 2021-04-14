output "private_subnet_name" {
  description 			= "Name for private subnet for Databricks workspace"
  value       			= azurerm_subnet.private_subnet.name
}

output "public_subnet_name" {
  description 			= "Name for public subnet for Databricks workspace"
  value       			= azurerm_subnet.public_subnet.name
}

output "private_subnet_id" {
  description                   = "Id of private subnet for Databricks workspace"
  value                         = azurerm_subnet.private_subnet.id
}

output "public_subnet_id" {
  description                   = "Id of public subnet for Databricks workspace"
  value                         = azurerm_subnet.public_subnet.id
}


