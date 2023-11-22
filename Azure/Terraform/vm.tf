# resource "azurerm_virtual_machine" "vm" {
#   count                 = length(var.instance_tags)
#   name                  = var.instance_tags[count.index]["value"]
#   location              = azurerm_resource_group.example.location
#   resource_group_name   = azurerm_resource_group.example.name
#   network_interface_ids = [azurerm_network_interface.example[count.index].id]
#   vm_size               = "Standard_DS1_v2"  # Example size, adjust as needed

#   tags = {
#     "Name" = var.instance_tags[count.index]["value"]
#   }

#   storage_os_disk {
#     name              = "osdisk-${var.instance_tags[count.index]["value"]}"
#     caching           = "ReadWrite"
#     create_option     = "FromImage"
#     managed_disk_type = "Standard_LRS"
#   }

#   storage_image_reference {
#     publisher = "Canonical"
#     offer     = "UbuntuServer"
#     sku       = "18.04-LTS"
#     version   = "latest"
#   }

#   os_profile {
#     computer_name  = var.instance_tags[count.index]["value"]
#     admin_username = "adminuser"
#     admin_password = "Password1234!"  # Example password, change for security
#   }

#   os_profile_linux_config {
#     disable_password_authentication = false
#   }

#   boot_diagnostics {
#     enabled     = true
#     storage_uri = azurerm_storage_account.example.primary_blob_endpoint
#   }
  
# }

# resource "azurerm_virtual_machine_extension" "vm_extension" {
#   count                = length(var.instance_tags)
#   name                 = "init-script-${var.instance_tags[count.index]["value"]}"
#   virtual_machine_id   = azurerm_virtual_machine.vm[count.index].id
#   publisher            = "Microsoft.Azure.Extensions"
#   type                 = "CustomScript"
#   type_handler_version = "2.0"

#   settings = <<SETTINGS
#     {
#         "commandToExecute": "apt-get update && apt-get install -y git wget"
#     }
# SETTINGS
# }

