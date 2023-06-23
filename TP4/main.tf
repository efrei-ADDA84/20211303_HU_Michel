provider "azurerm" {
  features {}
  subscription_id = "765266c6-9a23-4638-af32-dd1e32613047"
}

resource "azurerm_public_ip" "PUBLIC" {
  name                = "ip-20211303"
  location            = "francecentral"
  resource_group_name = "ADDA84-CTP"
  allocation_method   = "Dynamic"
}

resource "azurerm_network_interface" "NETWORK_INTERFACE" {
  name                = "Network_Interface-20211303"
  location            = "francecentral"
  resource_group_name = "ADDA84-CTP"

  ip_configuration {
    name                          = "config"
    subnet_id                     = "/subscriptions/765266c6-9a23-4638-af32-dd1e32613047/resourceGroups/ADDA84-CTP/providers/Microsoft.Network/virtualNetworks/network-tp4/subnets/internal"
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.PUBLIC.id
  }
}

resource "azurerm_linux_virtual_machine" "VM" {
  name                = "devops-20211303"
  location            = "francecentral"
  resource_group_name = "ADDA84-CTP"
  network_interface_ids = [azurerm_network_interface.NETWORK_INTERFACE.id]
  size                = "Standard_D2s_v3"
  admin_username       = "devops"
  disable_password_authentication = true

  admin_ssh_key {
    username       = "devops"
    public_key     = tls_private_key.ssh_key.public_key_openssh
  }

  os_disk {
    name              = "Michou_disk"
    caching           = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }
}

resource "tls_private_key" "ssh_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "null_resource" "write_public_key" {
  provisioner "local-exec" {
    command = "echo '${tls_private_key.ssh_key.public_key_openssh}' > ./public_key.pub"
  }
}

resource "null_resource" "write_private_key" {
  provisioner "local-exec" {
    command = "echo '${tls_private_key.ssh_key.private_key_pem}' > ./private_key.pem"
  }
}

output "public_key" {
  value = tls_private_key.ssh_key.public_key_openssh
  sensitive = true
}

output "private_key" {
  value = tls_private_key.ssh_key.private_key_pem
  sensitive = true
}