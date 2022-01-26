resource "random_integer" "int_prefix" {
  min = "1"
  max = "9999"
}

resource "azurerm_resource_group" "olivetech_base" {
  name     = "${var.org_name}-${var.app_name}-${var.env_name}"
  location = var.rg_location
  tags     = var.common_tags
}

resource "azurerm_network_security_group" "olivetech_base_nsg" {
  name                = "${var.org_name}-${var.app_name}-${var.nsg_name}"
  location            = azurerm_resource_group.olivetech_base.location
  resource_group_name = azurerm_resource_group.olivetech_base.name
}

resource "azurerm_virtual_network" "olivetech_base_vnet" {
  name                = "${azurerm_resource_group.olivetech_base.name}-vnet"
  resource_group_name = azurerm_resource_group.olivetech_base.name
  location            = azurerm_resource_group.olivetech_base.location
  address_space       = var.vnet_address_space
  tags                = var.common_tags
}

resource "azurerm_subnet" "olivetech_base_subnet" {
  name                 = var.subnet_name
  resource_group_name  = azurerm_resource_group.olivetech_base.name
  virtual_network_name = azurerm_virtual_network.olivetech_base_vnet.name
  address_prefixes     = var.subnet_address_prefixes
}

resource "azurerm_public_ip" "olivetech_base_publicip" {
  name                = var.publicip_name
  resource_group_name = azurerm_resource_group.olivetech_base.name
  location            = azurerm_resource_group.olivetech_base.location
  allocation_method   = var.publicip_allocation_method
  domain_name_label   = "${var.org_name}-${var.app_name}-${random_integer.int_prefix.id}"
  sku                 = lookup(var.public_ip_sku, var.rg_location)
  tags                = var.common_tags
}

resource "azurerm_network_interface" "olivetech_base_nic" {
  name                = "${var.org_name}-${var.network_interface}"
  location            = azurerm_resource_group.olivetech_base.location
  resource_group_name = azurerm_resource_group.olivetech_base.name
  tags                = var.common_tags

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.olivetech_base_subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.olivetech_base_publicip.id
  }
}

resource "azurerm_windows_virtual_machine" "olivetech_base_windows_vm" {
  name                = "olivetech-vm"
  resource_group_name = azurerm_resource_group.olivetech_base.name
  location            = azurerm_resource_group.olivetech_base.location
  size                = "Standard_D2s_v3"
  admin_username      = var.admin_username
  admin_password      = var.admin_password
  network_interface_ids = [
    azurerm_network_interface.olivetech_base_nic.id,
  ]

  os_disk {
    name                 = "osdisk"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-Datacenter"
    version   = "latest"
  }
}

resource "azurerm_virtual_machine_extension" "install_iis" {
  name                       = "vm_ext_install_iis"
  virtual_machine_id         = azurerm_windows_virtual_machine.olivetech_base_windows_vm.id
  publisher                  = "Microsoft.Compute"
  type                       = "CustomScriptExtension"
  type_handler_version       = "1.8"
  auto_upgrade_minor_version = true

  settings = <<SETTINGS
    {
        "commandToExecute": "powershell.exe -ExecutionPolicy Unrestricted Install-WindowsFeature -Name Web-Server -IncludeAllSubFeature -IncludeManagementTools"
    }
SETTINGS
}
