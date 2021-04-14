variable "name_prefix" {} 

variable "tenant_id" {}

variable "client_id" {}

variable "client_secret" {}

variable "aad_adlsgen2_passthru" {
type 			= bool
description		= "Credential passthrough to authenticate automatically to ADLS from Azure Databricks clusters using the identity that you use to log in to Azure Databricks"
default 		= true
}

variable "min_workers" {
type			= number
description		= "The minimum number of workers to which the cluster can scale down when underutilized. It is also the initial number of workers the cluster will have after creation"
default 		= 2 
}

variable "max_workers" {
type			= number		
description		= "The maximum number of workers to which the cluster can scale up when overloaded. max_workers must be strictly greater than min_workers"
default 		= 10
}

variable "auto_terminate" {
type 			= number	
description		= "Automatically terminate the cluster after being inactive in minutes.Threshold must be between 10 and 10000 minutes. Set it to 0 to  disable automatic termination"
default 		= 10
}


variable "databricks_resource_group_name" {
 description                    = "Resource group name for databricks workspace, value is passed of main module"
}



