resource "random_string" "rand_rg" {
  length  = 24
  special = false
  upper   = false
}

resource "azurerm_resource_group" "resource_group" {
  name     = random_string.rand_rg.result
  location = var.location
}

resource "azurerm_virtual_network" "virtual_network" {
  name                = "default"
  address_space       = ["172.16.0.0/16"]
  location            = var.location
  resource_group_name = azurerm_resource_group.resource_group.name
}

resource "azurerm_subnet" "vm_subnet" {
  name                 = "vm-subnet"
  resource_group_name  = azurerm_resource_group.resource_group.name
  virtual_network_name = azurerm_virtual_network.virtual_network.name
  address_prefix       = "172.16.0.0/24"
}

resource "azurerm_network_security_group" "vm_sg" {
  name                = "VM-NetworkSecurityGroup"
  location            = var.location
  resource_group_name = azurerm_resource_group.resource_group.name

  security_rule {
    name                       = "app"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "8080"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_public_ip" "public_ip" {
  name                = "vm-public_ip"
  location            = var.location
  resource_group_name = azurerm_resource_group.resource_group.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_network_interface" "network_interface" {
  name                      = "vm-nic"
  location                  = var.location
  resource_group_name       = azurerm_resource_group.resource_group.name
  network_security_group_id = azurerm_network_security_group.vm_sg.id

  ip_configuration {
    name                          = "vm-IPConfiguration"
    subnet_id                     = azurerm_subnet.vm_subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.public_ip.id
  }
}

# Enable Boot Diagnostics
resource "random_string" "rand_bd" {
  length  = 24
  special = false
  upper   = false
}

resource "azurerm_storage_account" "storage_account" {
  name                     = random_string.rand_bd.result
  resource_group_name      = azurerm_resource_group.resource_group.name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_virtual_machine" "virtual_machine" {
  name                             = "azure-vm"
  location                         = var.location
  resource_group_name              = azurerm_resource_group.resource_group.name
  network_interface_ids            = [azurerm_network_interface.network_interface.id]
  vm_size                          = "Standard_A1_v2"
  delete_os_disk_on_termination    = true
  delete_data_disks_on_termination = true

  storage_os_disk {
    name              = "vm-osdisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  boot_diagnostics {
    enabled     = true
    storage_uri = azurerm_storage_account.storage_account.primary_blob_endpoint
  }

  os_profile {
    computer_name  = "azure-vm"
    admin_username = "k8smm"
    admin_password = "Pass1234w0rd"
    custom_data    = templatefile("${path.module}/templates/startup.sh", { NAME = var.environment.name, BG_COLOR = var.environment.background_color })
  }
  os_profile_linux_config {
    disable_password_authentication = false
  }
}
