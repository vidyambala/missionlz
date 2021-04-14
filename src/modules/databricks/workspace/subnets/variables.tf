# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.
variable "resource_group_name" {
  description 			= "The name of the subnet's resource group"
  type        			= string
}

variable "virtual_network_name" {
  description 			= "The name of the subnet's virtual network"
  type        			= string
}


variable "service_endpoints" {
  description 			= "The service endpoints to optimize for this subnet"
  type        			= list(string)
  default 			= ["Microsoft.Storage"]
}

variable "enforce_private_link_endpoint_network_policies" {
  description 			= "Enforce Private Link Endpoints"
  type        			= bool
  default  			= false
}

variable "enforce_private_link_service_network_policies" {
  description 			= "Enforce Private Link Service"
  type        			= bool
  default			= false
}

variable "private_address_prefixes" {
  description 			= "Private address prefix to use for the subnet"
  type 				= list(string)
}


variable "public_address_prefixes" {
 description			= "Public address prefix to use for the subnet"
 type				= list(string)
}


