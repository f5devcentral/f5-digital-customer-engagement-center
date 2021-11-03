resource "azurerm_network_interface" "nic" {
    name                      = "${var.vm_name}-nic"
    location                  = var.location
    resource_group_name       = var.resource_group_name

    ip_configuration {
        name                          = "ipconfig0"
        subnet_id                     = var.subnet_id
        private_ip_address_allocation = "Dynamic"
    }
}

data "template_file" "cloud_init" {
  template = base64encode(file("${path.module}/cloud_init.yaml"))
}

# Create virtual machine
resource "azurerm_linux_virtual_machine" "vm" {
    name                  = var.vm_name
    location              = var.location
    resource_group_name   = var.resource_group_name
    network_interface_ids = [azurerm_network_interface.nic.id]
    size                  = var.vm_size
    custom_data           = data.template_file.cloud_init.rendered
    os_disk {
        name              = "${var.vm_name}-osDisk"
        caching           = "ReadWrite"
        storage_account_type = "Premium_LRS"
    }

    source_image_reference {
        publisher = "Canonical"
        offer     = "UbuntuServer"
        sku       = "18.04-LTS"
        version   = "latest"
    }

    computer_name  = var.vm_name
    admin_username = "azureuser"
    admin_password = var.upassword
    disable_password_authentication = false

    admin_ssh_key {
        username       = "azureuser"
        public_key     = var.f5_ssh_publickey
    }
/*
    boot_diagnostics {
        storage_account_uri = azurerm_storage_account.mystorageaccount.primary_blob_endpoint
    }
*/
}
