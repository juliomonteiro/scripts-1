#Configurar o PowerShell
Add-AzureRmAccount

$subscriptionId = "e9d30f1e-7aa1-4eb1-a84a-494829d63da0"

Select-AzureRmSubscription -SubscriptionId $SubscriptionId

#Criar variáveis
# The data center and resource name for your resources
$resourcegroupname = "SKYLAN-BD-2501"
$location = "eastus"
# The logical server name: Use a random value or replace with your own value (do not capitalize)
$servername = "server-$(Get-Random)"
# Set an admin login and password for your database
# The login information for the server
$adminlogin = "adminsql"
$password = "P@55word@@"
# The ip address range that you want to allow to access your server - change as appropriate
$startip = "0.0.0.0"
$endip = "0.0.0.0"
# The database name
$databasename = "SKYLAN-2501"


#Criar um grupo de recursos
New-AzureRmResourceGroup -Name $resourcegroupname -Location $location

#Criar um servidor lógico
New-AzureRmSqlServer -ResourceGroupName $resourcegroupname `
    -ServerName $servername `
    -Location $location `
    -SqlAdministratorCredentials $(New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $adminlogin, $(ConvertTo-SecureString -String $password -AsPlainText -Force))

#Configurar uma regra de firewall de servidor
New-AzureRmSqlServerFirewallRule -ResourceGroupName $resourcegroupname `
    -ServerName $servername `
    -FirewallRuleName "AllowSome" -StartIpAddress $startip -EndIpAddress $endip

#Criar um banco de dados no servidor com dados de exemplo
New-AzureRmSqlDatabase  -ResourceGroupName $resourcegroupname `
    -ServerName $servername `
    -DatabaseName $databasename `
    -SampleName "AdventureWorksLT" `
    -RequestedServiceObjectiveName "S0"