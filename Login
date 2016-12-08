$azureAccountName = 'user@domain.net'
$azurePassword = ConvertTo-SecureString "" -AsPlainText -Force

$psCred = New-Object System.Management.Automation.PSCredential($azureAccountName, $azurePassword)

Login-AzureRmAccount -Credential $psCred
