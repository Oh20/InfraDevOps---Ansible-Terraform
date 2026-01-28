variable "vm_name" {
    description = "Nome para a maquina virtual"
    type = string
    
    #validation {
    #  condition = (
    #    length(var.vm_name) > 5 && 
    #    length(var.vm_name) <=15 && 
    #    can(regex("^[a-zA-Z][a-zA-Z0-9-]*[a-zA-Z0-9]$", var.vm_name))
    #  )
    #  error_message = "O nome da VM precisa conter entre 5 e 15 caracteres"
    #}
}

variable "vm_size" {
    description = "Tamanho da maquina virtual"
    type = string
    default = "Standard_B2s"

    validation {
      condition     = can(regex("^Standard_[A-Z][0-9]+[a-z]*(_v[0-9]+)?$", var.vm_size))
      error_message = "vm_size deve ser um tamanho válido do Azure (ex: Standard_B2s, Standard_D2s_v3)."
    }
}

variable "vnet_name" {
    description = "Nome da rede virtual"
    type = string
    #default = "vNetDNR"
}

variable "subnet_name" {
    description = "Nome da sub-rede"
    type = string
    #default = "default"
}

variable "nsg_name" {
  description = "Nome do Network Security Group"
  type = string
  #default = "JUR-vm-nsg"
}

variable "location" {
    description = "Região onde os recursos serão criados"
    type = string
    #default = "East US"
}

variable "resource_group_name" {
  description = "Gurpo de recursos"
  type = string
}

variable "existing_vnet_rg_name" {
  description = "Nome do grupo de recursos da rede virtual existente"
  type = string
}

variable "admin_username" {
    description = "Nome do usuário administrador da VM"
    type = string
    default = "azureadmin"

    validation {
      condition = !contains(["admin", "administrator", "root", "sysadmin", "guest", "user"], lower(var.admin_username)
      )
        error_message = "O nome do usuário não pode ser 'admin', 'administrator', 'root' ou 'sysadmin'."
    }
}