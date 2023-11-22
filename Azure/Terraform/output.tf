# # Output for Resource Group
# output "resource_group_name" {
#   value       = azurerm_resource_group.example.name
#   description = "The name of the resource group"
# }

# output "resource_group_location" {
#   value       = azurerm_resource_group.example.location
#   description = "The location of the resource group"
# }

# # Output for Virtual Network
# output "virtual_network_name" {
#   value       = azurerm_virtual_network.example_vnet.name
#   description = "The name of the virtual network"
# }

# output "virtual_network_address_space" {
#   value       = azurerm_virtual_network.example_vnet.address_space
#   description = "The address space of the virtual network"
# }

# # Output for Subnet
# output "subnet_name" {
#   value       = azurerm_subnet.example_subnet.name
#   description = "The name of the subnet"
# }

# # Outputs for Virtual Machines
# output "virtual_machine_names" {
#   value = [for vm in azurerm_virtual_machine.vm : vm.name]
#   description = "List of names of the virtual machines"
# }

# output "virtual_machine_ids" {
#   value = [for vm in azurerm_virtual_machine.vm : vm.id]
#   description = "List of IDs of the virtual machines"
# }

# # Add other outputs as necessary...
