# Resource Group arguments 
rg_location = "Central US"
env_name    = "dev"
app_name    = "terratech"
org_name    = "olivetech"

# Network Security Group arguments 
nsg_name = "nsg"

# Virtual Network arguments 
vnet_address_space = ["10.0.0.0/16", "10.1.0.0/16"]

# Subnet arguments 
subnet_name             = "subnet-A"
subnet_address_prefixes = ["10.0.0.0/24"]

# Public IP arguments 
publicip_name              = "public-ip"
publicip_allocation_method = "Dynamic"

# Network Interface arguments 
network_interface = "base-nic"

# admin_credentials
admin_username = "olivetech-admin"
admin_password = "P@$$w0rd1234!"