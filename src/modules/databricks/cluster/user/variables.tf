variable "azure_databricks_workspace_id" {
}

variable "tenant_id" {}

variable "client_id" {}

variable "client_secret" {}

variable "admin_list" {
type                    = map(object({
        name    = string
        email   = string}))
default = {
           user1= {
                name = "Shanaa1"
                email = "useraa1@shan.com"
        }
         user2= {
                name = "Shanaa2"
                email = "useraa2@shan.com"
        }
         user3= {
                name = "Shanaa3"
                email = "useraa3@shan.com"
        }

}
}

variable "data_analyst_list" {
type			= map(object({
	name	= string
	email	= string}))
default = {
           user1= {
                name = "Shan1"
                email = "user1@shan.com"
        }
	 user2= {
                name = "Shan2"
                email = "user2@shan.com"
        }
	 user3= {
                name = "Shan3"
                email = "user3@shan.com"
        }

}
}






