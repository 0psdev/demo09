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
    type = string
}

variable "location_names" {
    description = "location name"
    type = string
}

variable "vnet_name" {
    description = "vnet name"
    type = string
}

variable "vnet_subnet" {
    description = "vnet subnet"
    type = list(string)
}

variable "snet_names" {
    description = "subnet name"
    type = list(string)
}

variable "snet_subnets" {
    description = "subnet subnets"
    type = map(list(string))
}