provider "azurerm" {
  features {}
}

terraform {
  required_providers {
    bigip = {
      source  = "f5networks/bigip"
      version = "1.8.0"
    }
  }
}

provider "bigip" {
  address  = var.address
  username = "admin"
  password = var.password
  port     = var.port
}

resource "bigip_as3" "as3-waf" {
  as3_json = file(var.declaration)
}

resource "azurerm_network_interface" "appnic" {
  count               = var.app_count
  name                = "app_nic"
  location            = var.location
  resource_group_name = var.resource_group

  ip_configuration {
    name                          = "testConfiguration"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Static"
    private_ip_address            = "10.2.1.101"
  }
}

resource "azurerm_managed_disk" "appdisk" {
  name                 = "datadisk_existing_${count.index}"
  count                = var.app_count
  location             = var.location
  resource_group_name  = var.resource_group
  storage_account_type = "Standard_LRS"
  create_option        = "Empty"
  disk_size_gb         = "1023"
}

resource "azurerm_availability_set" "avset" {
  name                         = "avset"
  location                     = var.location
  resource_group_name          = var.resource_group
  platform_fault_domain_count  = 2
  platform_update_domain_count = 2
  managed                      = true
}

resource "azurerm_virtual_machine" "app" {
  count                 = var.app_count
  name                  = "app_vm_${count.index}"
  location              = var.location
  availability_set_id   = azurerm_availability_set.avset.id
  resource_group_name   = var.resource_group
  network_interface_ids = [element(azurerm_network_interface.appnic.*.id, count.index)]
  vm_size               = "Standard_DS1_v2"


  # Uncomment this line to delete the OS disk automatically when deleting the VM
  delete_os_disk_on_termination = true

  # Uncomment this line to delete the data disks automatically when deleting the VM
  delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }

  storage_os_disk {
    name              = "myosdisk${count.index}"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  # Optional data disks
  storage_data_disk {
    name              = "datadisk_new_${count.index}"
    managed_disk_type = "Standard_LRS"
    create_option     = "Empty"
    lun               = 0
    disk_size_gb      = "1023"
  }

  storage_data_disk {
    name            = element(azurerm_managed_disk.appdisk.*.name, count.index)
    managed_disk_id = element(azurerm_managed_disk.appdisk.*.id, count.index)
    create_option   = "Attach"
    lun             = 1
    disk_size_gb    = element(azurerm_managed_disk.appdisk.*.disk_size_gb, count.index)
  }

  os_profile {
    computer_name  = format("appserver-%s", count.index)
    admin_username = "appuser"
    admin_password = var.upassword
    //custom_data    = filebase64("backend.sh")
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }

  tags = {
    Name = "${var.prefix}-app"
  }
}
