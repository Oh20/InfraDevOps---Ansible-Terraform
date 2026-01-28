#Configurando WinRM para administración remota
Write-Host "Iniciando configuración de WinRM..."

# Configurando perfil de rede para privado
write-Host "Configurando perfil de rede para Privado..."
Get-NetConnectionProfile | Set-NetConnectionProfile -NetworkCategory Private

# Habilitando PSRemoting
Write-Host "Habilitando PSRemoting..."
Enable-PSRemoting -Force -SkipNetworkProfileCheck

# Configurando WinRM
winrm quickconfig -q -force

# Permitindo a autenticação básica
Write-Host "Habilitando autenticação básica no WinRM..."
winrm set winrm/config/service/auth '@{Basic="true"}'

# Permitirindo conexões não criptografadas
Write-Host "Permitindo conexões não criptografadas no WinRM..."
winrm set winrm/config/service '@{AllowUnencrypted="true"}'

# Aumentando o limite de tamanho da mensagem
write-Host "Configurando limites de memoria para WinRM..."
winrm set winrm/config/winrs "@{MaxMemoryPerShellMB="1024"}"

# Configurar Firewall Para WinRM
Write-Host "Configurando regras de firewall para WinRM..."
New-NetFirewallRule -Name "WinRM-HTTP-In-TCP" `
    -DisplayName "Windows Remote Management (HTTP-In)" `
    -Enabled True `
    -Direction Inbound `
    -Protocol TCP `
    -LocalPort 5985 `
    -Action Allow
    -Profile Any
    ErrorAction SilentlyContinue

# Configurando Certificado Autoassinado para WinRM sobre HTTPS
Write-Host "Configurando certificado autoassinado para WinRM sobre HTTPS..."
$cert = New-SelfSignedCertificate -DnsName $hostName -CertStoreLocation "cert:\LocalMachine\My"

#Criando listener HTTPS
$httpsListener = Get-WSManInstance -ResourceURI winrm/config/listener -SelectorSet @{Address="*";Transport="HTTPS"} -ErrorAction SilentlyContinue
if (n$null -eq $httpsListener) {
    New-WSManInstance -ResourceURI winrm/config/listener `
        -SelectorSet @{Address="*";Transport="HTTPS"} `
        -ValueSet @{hostName=$hostName;CertificateThumbprint=$cert.Thumbprint}
    write-Host "Listener HTTPS criado com sucesso."
}

# Reiniciar Serviço WINRM 
Write-Host "Reiniciando o serviço WinRM..."
Restart-Service WinRM

# Verificar Status
Write-Host "Verificando o status do serviço WinRM..."
winrm enumerate winrm/config/listener

Write-Host "====================================="
Write-Host "WinRM configurado com sucesso!"
Write-Host "Porta HTTP: 5985"
Write-Host "Porta HTTPS: 5986"
Write-Host "Perfil de rede: Privado"
Write-Host "====================================="