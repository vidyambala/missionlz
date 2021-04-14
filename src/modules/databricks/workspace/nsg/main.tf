# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

resource "azurerm_network_security_group" "databricks_nsg" {
  name                		= "${var.name_prefix}-nsg"
  location            		= var.location
  resource_group_name 		= var.databricks_resource_group_name
}

resource "azurerm_subnet_network_security_group_association" "databricks_private_nsg_assoc" {
  subnet_id                	= var.private_subnet_id
  network_security_group_id 	= azurerm_network_security_group.databricks_nsg.id
}

resource "azurerm_subnet_network_security_group_association" "databricks_public_nsg_assoc" {
  subnet_id                 	= var.public_subnet_id
  network_security_group_id 	= azurerm_network_security_group.databricks_nsg.id
}


resource "azurerm_route_table" "databricks_routetable" {
  name                		= var.routetable_name
  resource_group_name 		= var.databricks_resource_group_name
  location            		= var.location
  tags                		= var.tags
}

resource "azurerm_route" "databricks_route" {
  name                   	= "default_route"
  resource_group_name    	= azurerm_route_table.databricks_routetable.resource_group_name
  route_table_name       	= azurerm_route_table.databricks_routetable.name
  address_prefix         	= "0.0.0.0/0"
  next_hop_type          	= "VirtualAppliance"
  next_hop_in_ip_address 	= var.firewall_ip_address
}

resource "azurerm_subnet_route_table_association" "databricks_private_routetable_assc" {
  subnet_id      		= var.private_subnet_id
  route_table_id 		= azurerm_route_table.databricks_routetable.id
}

resource "azurerm_subnet_route_table_association" "databricks_public_routetable_assc" {
  subnet_id      		= var.public_subnet_id
  route_table_id 		= azurerm_route_table.databricks_routetable.id
}

locals {
  nsg_log_categories 		= ["NetworkSecurityGroupEvent", "NetworkSecurityGroupRuleCounter"]
}

resource "azurerm_monitor_diagnostic_setting" "databricks_nsg_diag" {
  name                       	= "${azurerm_network_security_group.databricks_nsg.name}-nsg-diagnostics"
  target_resource_id         	= azurerm_network_security_group.databricks_nsg.id
  storage_account_id         	= var.log_analytics_storage_id
  log_analytics_workspace_id 	= var.log_analytics_workspace_id

  dynamic "log" {
    for_each 			= local.nsg_log_categories
    content {
      category 			= log.value
      enabled  			= true

      retention_policy {
        enabled 		= false
      }
    }
  }
}


resource "azurerm_network_watcher_flow_log" "nsgfl" {
  network_watcher_name 		= "NetworkWatcher_${var.location}"
  resource_group_name  		= "NetworkWatcherRG"

  network_security_group_id 	= azurerm_network_security_group.databricks_nsg.id
  storage_account_id        	= var.log_analytics_storage_id
  enabled                   	= true

  retention_policy {
    enabled 			= true
    days    			= var.flow_log_retention_in_days
  }
}

