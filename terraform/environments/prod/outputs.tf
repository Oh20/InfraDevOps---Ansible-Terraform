output "vm_name"{
    description = "Nome da VM criada"
    value = module.windows_vm.vm_name
}

output "public_ip_address"{
    description = "Endereço de IP Publico"
    value = module.windows_vm.public_ip_address
}

output "private_ip_address"{
    description = "Endereço de IP Privado"
    value = module.windows_vm.private_ip_address
}

output "admin_password" {
  description = "Senha de admin"
  value = module.windows_vm.admin_password
  sensitive = true
}