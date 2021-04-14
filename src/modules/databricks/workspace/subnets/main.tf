# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

resource "azurerm_subnet" "private_subnet" {
  name                 		= "prisubnet" 
  resource_group_name  		= var.resource_group_name
  virtual_network_name 		= var.virtual_network_name
  address_prefixes     		= var.private_address_prefixes

  service_endpoints 		= var.service_endpoints

  enforce_private_link_endpoint_network_policies 	= var.enforce_private_link_endpoint_network_policies
  enforce_private_link_service_network_policies  	= var.enforce_private_link_service_network_policies
  delegation {
        name                    = "databricks_private_delegation"

        service_delegation {
                name            = "Microsoft.Databricks/workspaces"
    }
  }
}

resource "azurerm_subnet" "public_subnet" {
  name                		 = "pubsubnet"
  resource_group_name  		= var.resource_group_name
  virtual_network_name 		= var.virtual_network_name
  address_prefixes     		= var.public_address_prefixes

  service_endpoints 		= var.service_endpoints

  enforce_private_link_endpoint_network_policies 	= var.enforce_private_link_endpoint_network_policies
  enforce_private_link_service_network_policies  	= var.enforce_private_link_service_network_policies
  delegation {
  	name                   	= "databricks_public_delegation"

    	service_delegation {
     		name            = "Microsoft.Databricks/workspaces"
    }
  }

}


