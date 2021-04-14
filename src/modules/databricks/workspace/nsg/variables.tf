# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

variable "name_prefix" {
  description                   = "Prefix to be used for dynamically generated resource names"
}

variable "location" {
  description                   = "The location/region for your resources. Run 'az account list-locations -o table' to get location list"
}

variable "databricks_resource_group_name" {
 description                    = "Resource group name for databricks workspace. Optional and uses output of a module"
}

locals {
databricks_nsg_rules = {

    "Microsoft.Databricks-workspaces_UseOnly_databricks-worker-to-worker-inbound"= {
      name                       = "Microsoft.Databricks-workspaces_UseOnly_databricks-worker-to-worker-inbound"
      priority                   = 100
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "*"
      source_port_range          = "*"
      destination_port_range     = "*"
      source_address_prefix      = "VirtualNetwork"
      destination_address_prefix = "VirtualNetwork"
      description		 = "Required for worker nodes communication within a cluster."
    }

    "Microsoft.Databricks-workspaces_UseOnly_databricks-worker-to-databricks-webapp" = {
      name                       = "Microsoft.Databricks-workspaces_UseOnly_databricks-worker-to-databricks-webapp"
      priority                   = 100
      direction                  = "Outbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "443"
      source_address_prefix      = "VirtualNetwork"
      destination_address_prefix = "AzureDatabricks"
      description		 = "Required for workers communication with Databricks Webapp."
    }

  "Microsoft.Databricks-workspaces_UseOnly_databricks-worker-to-sql"= {
      name                       = "Microsoft.Databricks-workspaces_UseOnly_databricks-worker-to-sql"
      priority                   = 101
      direction                  = "Outbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "3306"
      source_address_prefix      = "VirtualNetwork"
      destination_address_prefix = "sql"
      description		 = "Required for workers communication with Azure SQL services."
    }

   "Microsoft.Databricks-workspaces_UseOnly_databricks-worker-to-storage"= {
      name                       = "Microsoft.Databricks-workspaces_UseOnly_databricks-worker-to-storage"
      priority                   = 102
      direction                  = "Outbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "443"
      source_address_prefix      = "VirtualNetwork"
      destination_address_prefix = "Storage"
      description		 = "Required for workers communication with Azure Storage services."
    }

   "Microsoft.Databricks-workspaces_UseOnly_databricks-worker-to-worker-outbound" = {
      name                       = "Microsoft.Databricks-workspaces_UseOnly_databricks-worker-to-worker-outbound"
      priority                   = 103
      direction                  = "Outbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "*"
      source_address_prefix      = "VirtualNetwork"
      destination_address_prefix = "VirtualNetwork"
      description 		 = "Required for worker nodes communication within a cluster."
    }

   "Microsoft.Databricks-workspaces_UseOnly_databricks-worker-to-eventhub"= {
      name                       = "Microsoft.Databricks-workspaces_UseOnly_databricks-worker-to-eventhub"
      priority                   = 104
      direction                  = "Outbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "9093"
      source_address_prefix      = "VirtualNetwork"
      destination_address_prefix = "EventHub"
      description		 = "Required for worker communication with Azure Eventhub services."
    }
  }

}


variable "private_subnet_name" {
 description                    = "Name of private subnet, value is passed from subnets module"
}

variable "public_subnet_name" {
 description                    = "Name of private subnet, value is passed from subnets module"
}

variable "private_subnet_id" {
 description                    = "Id of private subnet, value is passed from subnets module"
}

variable "public_subnet_id" {
 description                    = "Id of private subnet, value is passed from subnets module"
}


variable "routetable_name" {
  description = "The name of the subnet's route table"
  type        = string
}

variable "firewall_ip_address" {
  description = "The IP Address of the Firewall"
  type        = string
}

variable "log_analytics_storage_id" {
  description = "The id of the storage account that stores log analytics diagnostic logs"
}

variable "log_analytics_workspace_id" {
  description = "The id of the log analytics workspace"
}

variable "flow_log_retention_in_days" {
  description = "The number of days to retain flow log data"
  default     = "7"
}

variable "tags" {}

