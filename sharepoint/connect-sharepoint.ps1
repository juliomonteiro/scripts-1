$portal = "https://holdingclube-admin.sharepoint.com"
$username = "admin@clubeservicos.onmicrosoft.com"
$password = "tkx31Na9@@"
$cred = New-Object -TypeName System.Management.Automation.PSCredential -argumentlist $username, $(convertto-securestring $password -asplaintext -force)
Connect-SPOService -Url $portal -Credential $cred