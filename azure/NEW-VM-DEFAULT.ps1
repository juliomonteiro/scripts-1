#Configurar o PowerShell
Add-AzureRmAccount

$subscriptionId = "e9d30f1e-7aa1-4eb1-a84a-494829d63da0"

Select-AzureRmSubscription -SubscriptionId $SubscriptionId


#Criar um grupo de recursos
$ResourceGroupName = "25-01-2018"

#Defina um local de uma região de destino do Azure para todos os recursos de VM
$Location = "East US"

#Crie o grupo de recursos
New-AzureRmResourceGroup -Name $ResourceGroupName -Location $Location

#Criar máquina virtual
New-AzureRmVm `
    -ResourceGroupName "25-01-2018" `
    -Name "SKYVM-25-01M" `
    -Location "East US" `
    -VirtualNetworkName "myVnet" `
    -SubnetName "mySubnet" `
    -SecurityGroupName "myNetworkSecurityGroup" `
    -PublicIpAddressName "myPublicIpAddress" `
    -OpenPorts 80,3389

Get-AzureRmPublicIpAddress -ResourceGroupName myResourceGroup | Select IpAddress