variable "app_name" {
  description = "The name of the app"
  type        = string
}

variable "env_name" {
  description = "Environment Name"
  type        = string
}

variable "rg_location" {
  description = "The Azure Region in which resource groups should be created."
  type        = string
}

variable "org_name" {
  description = "The name of the organization"
  type        = string
}

variable "nsg_name" {
  description = "The name of the NSG"
  type        = string
}

variable "vnet_address_space" {
  description = "Virtual Network Address Space"
  type        = list(string)
}

variable "subnet_name" {
  description = "Virtual Network Subnet Name"
  type        = string
}

variable "subnet_address_prefixes" {
  description = "Subnet address_prefixes"
  type        = list(string)
}

variable "publicip_name" {
  description = "Name of the public ip address"
  type        = string
}

variable "publicip_allocation_method" {
  description = "Allocation method type"
  type        = string
}

variable "public_ip_sku" {
  description = "Azure Public IP Address SKU"
  type        = map(string)
  default = {
    "Central US" = "Basic"
    "eastus"     = "Standard"
    "westus"     = "Basic"
    "westus2"    = "Standard"
    "southindia" = "Basic"
    "westindia"  = "Standard"
  }
}

# Assign When Prompted using CLI
variable "network_interface" {
  description = "Name of network interface card"
  type        = string
}

# Assign When Prompted using CLI
variable "admin_username" {
  description = "Username of admin"
  type        = string
  sensitive   = true
}

variable "admin_password" {
  description = "Password of admin"
  type        = string
  sensitive   = true
}

variable "common_tags" {
  description = "Common Tags for Azure Resources"
  type        = map(string)
  default = {
    Org_Name    = "terratech"
    Environment = "dev"
    Maintainer  = "p.jailwal@olivetech.io"
    Provisioner = "terrabot"
    Cost_center = "p.jailwal-Pay-As-You-Go"
  }
}
