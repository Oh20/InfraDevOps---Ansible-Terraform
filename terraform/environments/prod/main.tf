module "windows_vm"{
    source = "../../modules/windows-vm"

    vm_name            = var.vm_name
    vm_size = var.vm_size
    location = var.location
    resource_group_name = var.resource_group_name
    existing_vnet_rg_name = var.existing_vnet_rg_name
    vnet_name = var.vnet_name
    subnet_name = var.subnet_name
    nsg_name = var.nsg_name
    admin_username = var.admin_username
}