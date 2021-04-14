# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

variable "name_prefix" {
  description 			= "Prefix to be used for dynamically generated resource names"
} 

variable "location" {
  description 			= "The location/region for your resources. Run 'az account list-locations -o table' to get location list"
}

variable "databricks_ws_sku" {
  description		 	= "The sku for Databricks workspace. As of 3/30/2021 ,the possible values are standard, premium, or trial"
  default 			= "premium"
}

variable "databricks_environment" {
  description 			= "Environment name to be specified in tag"
  default     			= "Development"
}

variable "databricks_resource_group_name" {
 description			= "Resource group name for databricks workspace, value is passed of main module"
}


variable "no_public_ip" {
 description			= "Allow or disallow public IP address"
 type				= bool
 default 			= false
}

variable "virtual_network_id" {
 description                    = "Resource Id of virtual network, value is passed from common virtual-network module"
}

variable "private_subnet_name" {
 description			= "Name of private subnet, value is passed from subnets module"
}

variable "public_subnet_name" {
 description                    = "Name of private subnet, value is passed from subnets module"
}
