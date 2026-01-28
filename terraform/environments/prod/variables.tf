variable "vm_name" {
  description = "Nome da VM"
  type        = string
  
}

variable "vm_size" {
  description = "Tamanho da VM"
  type        = string
}

variable "location" {
  description = "Localização da VM"
  type        = string
}

variable "vnet_name" {
  description = "Nome da VNet"
  type        = string
}
variable "subnet_name" {
  description = "Nome da Sub-rede"
  type        = string
}
variable "nsg_name" {
  description = "Nome do NSG"
  type        = string
}
variable "resource_group_name" {
  description = "Nome do Grupo de Recursos"
  type        = string
}
variable "existing_vnet_rg_name" {
  description = "Nome do Grupo de Recursos da VNet existente"
  type        = string
}
variable "admin_username" {
  description = "Nome do usuário administrador da VM"
  type        = string
}