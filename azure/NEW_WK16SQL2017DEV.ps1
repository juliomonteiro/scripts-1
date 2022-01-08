#Configurar o PowerShell
Add-AzureRmAccount

$subscriptionId = "e9d30f1e-7aa1-4eb1-a84a-494829d63da0"

Select-AzureRmSubscription -SubscriptionId $SubscriptionId

#Criar um grupo de recursos
$ResourceGroupName = "25-01-2018"

#Defina um local de uma região de destino do Azure para todos os recursos de VM
$Location = "eastus"

#Crie o grupo de recursos
New-AzureRmResourceGroup -Name $ResourceGroupName -Location $Location

#Definir as configurações de rede
$SubnetName = $ResourceGroupName + "subnet"
$VnetName = $ResourceGroupName + "vnet"
$PipName = $ResourceGroupName + $(Get-Random)

# Create a subnet configuration
$SubnetConfig = New-AzureRmVirtualNetworkSubnetConfig -Name $SubnetName -AddressPrefix 192.168.1.0/24

# Create a virtual network
$Vnet = New-AzureRmVirtualNetwork -ResourceGroupName $ResourceGroupName -Location $Location `
   -Name VnetName -AddressPrefix 192.168.0.0/16 -Subnet $SubnetConfig

# Create a public IP address and specify a DNS name
$Pip = New-AzureRmPublicIpAddress -ResourceGroupName $ResourceGroupName -Location $Location `
   -AllocationMethod Static -IdleTimeoutInMinutes 4 -Name $PipName



#Crie um grupo de segurança de rede. Configure regras para permitir conexões da área de trabalho remota (RDP) e do SQL Server.
# Rule to allow remote desktop (RDP)
$NsgRuleRDP = New-AzureRmNetworkSecurityRuleConfig -Name "RDPRule" -Protocol Tcp `
   -Direction Inbound -Priority 1000 -SourceAddressPrefix * -SourcePortRange * `
   -DestinationAddressPrefix * -DestinationPortRange 3389 -Access Allow

#Rule to allow SQL Server connections on port 1433
$NsgRuleSQL = New-AzureRmNetworkSecurityRuleConfig -Name "MSSQLRule"  -Protocol Tcp `
   -Direction Inbound -Priority 1001 -SourceAddressPrefix * -SourcePortRange * `
   -DestinationAddressPrefix * -DestinationPortRange 1433 -Access Allow

# Create the network security group
$NsgName = $ResourceGroupName + "nsg"
$Nsg = New-AzureRmNetworkSecurityGroup -ResourceGroupName $ResourceGroupName `
   -Location $Location -Name $NsgName `
   -SecurityRules $NsgRuleRDP,$NsgRuleSQL


#Crie a interface de rede.
$InterfaceName = $ResourceGroupName + "int"
$Interface = New-AzureRmNetworkInterface -Name $InterfaceName `
   -ResourceGroupName $ResourceGroupName -Location $Location `
   -SubnetId $VNet.Subnets[0].Id -PublicIpAddressId $Pip.Id `
   -NetworkSecurityGroupId $Nsg.Id


#Criar a VM de SQL
#user:   adminsql
#pass:   P@ssW0rd@@2018

# Define a credential object
$SecurePassword = ConvertTo-SecureString 'P@ssW0rd@@2018' `
   -AsPlainText -Force
$Cred = New-Object System.Management.Automation.PSCredential ("adminsql", $SecurePassword)

#cria uma VM do SQL Server 2017 Developer Edition no Windows Server 2016.

# Create a virtual machine configuration
$VMName = $ResourceGroupName + "VM"
$VMConfig = New-AzureRmVMConfig -VMName $VMName -VMSize Standard_DS2 | `
   Set-AzureRmVMOperatingSystem -Windows -ComputerName $VMName -Credential $Cred -ProvisionVMAgent -EnableAutoUpdate | `
   Set-AzureRmVMSourceImage -PublisherName "MicrosoftSQLServer" -Offer "SQL2017-WS2016" -Skus "SQLDEV" -Version "latest" | `
   Add-AzureRmVMNetworkInterface -Id $Interface.Id

# Create the VM
New-AzureRmVM -ResourceGroupName $ResourceGroupName -Location $Location -VM $VMConfig


#Instalar o SQL IaaS Agent
Set-AzureRmVMSqlServerExtension -ResourceGroupName $ResourceGroupName -VMName $VMName -name "SQLIaasExtension" -version "1.2" -Location $Location

#Área de trabalho remota na VM
Get-AzureRmPublicIpAddress -ResourceGroupName $ResourceGroupName | Select IpAddres