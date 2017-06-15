
$osVolEncrypted = {(Get-AzureRmVMDiskEncryptionStatus -ResourceGroupName $_.ResourceGroupName -VMName $_.Name).OsVolumeEncrypted}

$dataVolEncrypted= {(Get-AzureRmVMDiskEncryptionStatus -ResourceGroupName $_.ResourceGroupName -VMName $_.Name).DataVolumesEncrypted}

Get-AzureRmVm | Format-Table @{Label=”MachineName”; Expression={$_.Name}}, @{Label=”OsVolumeEncrypted”; Expression=$osVolEncrypted}, @{Label=”DataVolumesEncrypted”; Expression=$dataVolEncrypted}
