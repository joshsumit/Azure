registration url
$Account = Get-AzureRmAutomationAccount -ResourceGroupName $AutomationAccountResourceGroup -Name $AutomationAccountName
$RegistrationInfo = $Account | Get-AzureRmAutomationRegistrationInfo
$RegistrationInfo.Endpoint

Get Reports

$node = get-azurermautomationDscNode
$report = get-azurermautomationDscNodeReport -NodeId
$report | Export-azurermautomationDscNodeReportContent -OutputFolder 
