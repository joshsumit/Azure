Login-AzureRmAccount

$resourceGroup = "MEP-Dev8-CMN"
$location =  "SouthIndia"
$storageaccountName = "multinicvmst"
$vNetName = "myVNet"
$frontEndSubnetName = "myFrontEndSubnet"
$backEndSubnetName = "mybackEndSubnet"
$vNetAddressPrefix = "192.168.0.0/16" 
$frontEndSubnetPrefix = "192.168.1.0/24"
$backEndSubnetPrefix = "192.168.2.0/24"
$nic1Name = "Nic1"
$nic2Name = "Nic2"
$vmName = "VM1"



New-AzureRmResourceGroup -Name $resourceGroup -Location $location

$storageAcc = New-AzureRmStorageAccount -ResourceGroupName $resourceGroup -Kind Storage -SkuName Standard_GRS `
-Location $location -Name $storageaccountName 

$mySubnetFrontEnd = New-AzureRmVirtualNetworkSubnetConfig -Name $frontEndSubnetName `
                    -AddressPrefix $frontEndSubnetPrefix

$mySubnetBackEnd = New-AzureRmVirtualNetworkSubnetConfig -Name $backEndSubnetName `
                    -AddressPrefix $backEndSubnetPrefix

$myVnet = New-AzureRmVirtualNetwork -ResourceGroupName $resourceGroup `
            -Location $location -Name $vNetName -AddressPrefix $vNetAddressPrefix `
            -Subnet $mySubnetFrontEnd, $mySubnetBackEnd

$frontEnd = $myVnet.Subnets|?{$_.Name -eq $frontEndSubnetName}
$myNic1 = New-AzureRmNetworkInterface -ResourceGroupName $resourceGroup  `
-Location $location -Name $nic1Name -SubnetId $frontEnd.Id


$backEnd = $myVnet.Subnets|?{$_.Name -eq $backEndSubnetName}
$myNic2 = New-AzureRmNetworkInterface -ResourceGroupName $resourceGroup `
-Location $location -Name $nic2Name -SubnetId $backEnd.Id

$vmcred = Get-Credential
$vmConfig = New-AzureRmVMConfig -VMName $vmName -VMSize "Standard_DS1_v2"
$vmConfig = Set-AzureRmVMOperatingSystem -VM $vmConfig -Windows -ComputerName $vmName `
                                         -Credential $vmcred -ProvisionVMAgent -EnableAutoUpdate

$vmConfig = Set-AzureRmVMSourceImage -VM $vmConfig -PublisherName "MicrosoftWindowsServer" `
                                     -Offer "WindowsServer" -Skus "2012-R2-Datacenter" -Version "latest"

$vmConfig = Add-AzureRmVMNetworkInterface -VM $vmConfig -Id $myNic1.Id -Primary
$vmConfig = Add-AzureRmVMNetworkInterface -VM $vmConfig -Id $myNic2.Id

$blobPath = "vhds/WindowsVMosDisk.vhd"
$osDiskUri = $storageAcc.PrimaryEndpoints.Blob.ToString() + $blobPath
$diskName = "windowsvmosdisk"
$vmConfig = Set-AzureRmVMOSDisk -VM $vmConfig -Name $diskName -VhdUri $osDiskUri `
                                -CreateOption "fromImage"


New-AzureRmVM -VM $vmConfig -ResourceGroupName $resourceGroup -Location $location

Stop-AzureRmVM -Name $vmName -ResourceGroupName $resourceGroup

#$vm = Get-AzureRmVm -Name $vmName -ResourceGroupName $resourceGroup

#$nicId = (Get-AzureRmNetworkInterface -ResourceGroupName $resourceGroup -Name $nic1Name).Id
#Add-AzureRmVMNetworkInterface -VM $vm -Id $nicId -Primary | Update-AzureRmVm -ResourceGroupName $resourceGroup

#One of the NICs on a multi-NIC VM needs to be Primary so we're setting the new NIC as primary.
#If your previous NIC on the VM is Primary, then you do not need to specify the -Primary switch. 
#If you want to switch the Primary NIC on the VM, follow the steps below


#############################
$vm = Get-AzureRmVm -Name $vmName -ResourceGroupName $resourceGroup

# Find out all the NICs on the VM and find which one is Primary
$vm.NetworkProfile.NetworkInterfaces

# Set the NIC 0 to be primary
$vm.NetworkProfile.NetworkInterfaces[0].Primary = $true
$vm.NetworkProfile.NetworkInterfaces[1].Primary = $false

# Update the VM state in Azure
Update-AzureRmVM -VM $vm -ResourceGroupName $resourceGroup

#########################

