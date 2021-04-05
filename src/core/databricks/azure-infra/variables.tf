# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.
#################################
# Global Configuration
#################################
variable "tf_environment" {
  description = "The Terraform backend environment e.g. public or usgovernment"
}

variable "mlz_cloud" {
  description = "The Azure Cloud to deploy to e.g. AzureCloud or AzureUSGovernment"
}

variable "mlz_tenantid" {
  description = "The Azure tenant for the deployment"
}

variable "mlz_location" {
  description = "The Azure region for most Mission LZ resources"
}

variable "mlz_metadatahost" {
  description = "The metadata host for the Azure Cloud e.g. management.azure.com"
}

variable "mlz_clientid" {
  description = "The account to deploy with"
}

variable "mlz_clientsecret" {
  description = "The account to deploy with"
}

#################################
# Databricks Workspace Congiguration
#################################

variable "name_prefix" {}


#variable "deploymentname" {
#  description = "A name for the deployment"
#}

variable "databricks_subid" {
  description = "Subscription ID for the databricks deployment"
}

variable "databricks_vnet_address_space" {
  description = "VNET address for Databricks"
}

variable "databricks_rgname" {}
variable "saca_subid" {}
variable "deploymentname" {}
variable "saca_rgname" {}
variable "saca_lawsname" {}
variable "saca_fwname" {}
variable "saca_vnetname" {}
variable "databricks_vnetname" {}
variable "private_subnet_name" {}
variable "virtual_network_id" {}
variable "public_subnet_name" {}


variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

variable "subnets" {
  description = "A complex object that describes subnets."
  type = map(object({
    name              = string
    address_prefixes  = list(string)
    service_endpoints = list(string)

    enforce_private_link_endpoint_network_policies = bool
    enforce_private_link_service_network_policies  = bool

    nsg_name = string
    nsg_rules = map(object({
      name                       = string
      priority                   = string
      direction                  = string
      access                     = string
      protocol                   = string
      source_port_range          = string
      destination_port_range     = string
      source_address_prefix      = string
      destination_address_prefix = string
    }))

    routetable_name = string
  }))
}

