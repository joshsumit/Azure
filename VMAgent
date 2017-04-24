
  $vms = Get-AzureRmVM -Name  $vmName  -ResourceGroupName $resourceGroupName
  $agent = $vms | Select -ExpandProperty OSProfile | Select -ExpandProperty Windowsconfiguration | Select ProvisionVMAgent
