
$resourceGroup = "myRG"
$location =  "SouthIndia"
$lb = Get-AzureRmLoadBalancer -Name 'mylb'  -ResourceGroupName $resourceGroup 
$ip = New-AzureRmPublicIpAddress -Name 'myip3' -ResourceGroupName  $resourceGroup -Location $location

Add-AzureRmLoadBalancerFrontendIpConfig -LoadBalancer $lb -PublicIpAddress $ip -Name 'feip'

$fic = get-AzureRmLoadBalancerFrontendIpConfig -LoadBalancer $lb   -Name 'feip'


Set-AzureRmLoadBalancer -LoadBalancer $lb  