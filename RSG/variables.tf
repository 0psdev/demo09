variable "subscription_id" {
    description = "subscription id"
    type = string
}

variable "tenant_id" {
    description = "tenant id"
    type = string
}

variable "rsg_names" {
    description = "resource group name"
    type = list(string)
}

variable "location_names" {
    description = "location name"
    type = map(string)
}