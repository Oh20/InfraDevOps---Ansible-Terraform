output "admin_password" {
  description = "Senha de ADMIN gerada aleatoriamente para a VM"
  value       = random_password.admin_password.result
  sensitive   = true
}

output "public_ip_address" {
  description = "Endereço de IP público da VM"
  value       = azurerm_public_ip.pip.ip_address
}

output "private_ip_address" {
  description = "Endereço de IP privado da VM"
  value       = azurerm_network_interface.nic.private_ip_address
}

output "vm_name" {
  description = "Nome da VM"
  value = azurerm_windows_virtual_machine.main.name
}