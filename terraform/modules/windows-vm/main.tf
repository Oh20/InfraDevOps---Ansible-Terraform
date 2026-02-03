data "azurerm_resource_group" "existing" {
  name = var.resource_group_name
}

data "azurerm_virtual_network" "existing" {
  name                = var.vnet_name
  resource_group_name = var.existing_vnet_rg_name
}

data "azurerm_subnet" "existing" {
  name                 = var.subnet_name
  virtual_network_name = var.vnet_name
  resource_group_name  = var.existing_vnet_rg_name
}

resource "random_password" "admin_password" {
  length           = 16
  special          = true
}

resource "azurerm_public_ip" "pip" {
  name                = "${var.vm_name}-public-ip"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku = "Standard"
  allocation_method   = "Static"
}

resource "azurerm_network_interface" "nic"{
  name = "${var.vm_name}-nic"
  location = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name = "${var.vm_name}-ipconfig"
    subnet_id = data.azurerm_subnet.existing.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.pip.id
  }
}

resource "azurerm_windows_virtual_machine" "main" {
  name                = var.vm_name
  location            = var.location
  resource_group_name = var.resource_group_name
  size                = var.vm_size
  admin_username      = var.admin_username
  admin_password      = random_password.admin_password.result

  network_interface_ids = [
    azurerm_network_interface.nic.id
  ]

  os_disk {
    name                 = "${var.vm_name}-osdisk"
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS" 
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2022-datacenter"
    version   = "latest"
  }
}

resource "azurerm_virtual_machine_extension" "winrm" {
  name = "${var.vm_name}-winrm-config"
  virtual_machine_id = azurerm_windows_virtual_machine.main.id
  publisher = "Microsoft.Compute"
  type = "CustomScriptExtension"
  type_handler_version = "1.10"

  settings = jsonencode({
    "commandToExecute" = "powershell -ExecutionPolicy Unrestricted -File ConfigureWinRM.ps1"
  })

  protected_settings = jsonencode({
    "fileUris" = []
    script = base64encode(file("${path.module}/scripts/ConfigureWinRM.ps1"))
  })

  tags = {
    Purpose = "WinRM Configuration for Ansible"
  }
}

#resource "azurerm_virtual_machine_extension" "winrm" {
#  name                 = "${var.vm_name}-winrm-config"
#  virtual_machine_id   = azurerm_windows_virtual_machine.main.id
#  publisher            = "Microsoft.Compute"
#  type                 = "CustomScriptExtension"
#  type_handler_version = "1.10"
#
#  protected_settings = jsonencode({
#    commandToExecute = <<-EOT
#      powershell -ExecutionPolicy Unrestricted -Command "
#        Write-Host 'Iniciando configuração do WinRM...';
#        Get-NetConnectionProfile | Set-NetConnectionProfile -NetworkCategory Private;
#        Enable-PSRemoting -Force -SkipNetworkProfileCheck;
#        winrm quickconfig -q -force;
#        winrm set winrm/config/service/auth '@{Basic=\"true\"}';
#        winrm set winrm/config/service '@{AllowUnencrypted=\"true\"}';
#        winrm set winrm/config/winrs '@{MaxMemoryPerShellMB=\"1024\"}';
#        New-NetFirewallRule -Name 'WinRM-HTTP-In-TCP' -DisplayName 'Windows Remote Management (HTTP-In)' -Enabled True -Direction Inbound -Protocol TCP -LocalPort 5985 -Action Allow -Profile Any -ErrorAction SilentlyContinue;
#        New-NetFirewallRule -Name 'WinRM-HTTPS-In-TCP' -DisplayName 'Windows Remote Management (HTTPS-In)' -Enabled True -Direction Inbound -Protocol TCP -LocalPort 5986 -Action Allow -Profile Any -ErrorAction SilentlyContinue;
#        \$cert = New-SelfSignedCertificate -DnsName \$env:COMPUTERNAME -CertStoreLocation Cert:\LocalMachine\My;
#        New-WSManInstance -ResourceURI winrm/config/listener -SelectorSet @{Address='*';Transport='HTTPS'} -ValueSet @{Hostname=\$env:COMPUTERNAME;CertificateThumbprint=\$cert.Thumbprint} -ErrorAction SilentlyContinue;
#        Restart-Service WinRM;
#        Write-Host 'WinRM configurado com sucesso!';
#      "
#    EOT
#  }) 

#  tags = {
#    Purpose = "WinRM Configuration for Ansible"
#  }
#}