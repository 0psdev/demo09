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

variable "snet_name" {
    description = "subnet name"
    type = string  
}

variable "vm_names" {
    description = "vm name"
    type = list(string)
  
}

variable "vm_specs" {
    description = "vm specs"
    type = map(object({
        vm_size = string
        #publisher = string
        #offer = string
        #sku = string
        #version = string
        disk_size_gb = number
    }))
  
}