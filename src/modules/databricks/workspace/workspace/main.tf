# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

resource "azurerm_databricks_workspace" "databricks-ws" {
  name                		= "${var.name_prefix}-db-ws"
  resource_group_name 		= var.databricks_resource_group_name
  location            		= var.location 
  sku                 		= var.databricks_ws_sku
  custom_parameters 		 {
	public_subnet_name	= var.private_subnet_name
	private_subnet_name	= var.public_subnet_name
	virtual_network_id 	= var.virtual_network_id
	no_public_ip		= var.no_public_ip
 	}
}
