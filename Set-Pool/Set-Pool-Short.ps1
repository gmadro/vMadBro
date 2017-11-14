$pools = Get-ResourcePool | Where-Object {$_.Name -ne "Resources"}
ForEach ($pool in $pools){
	$vmCount = $pool.ExtensionData.vm.count
	$poolShare = read-host ("Enter share value for Pool: {0}" -f $pool)
	$shares = $poolShare * $vmCount
	Set-ResourcePool -ResourcePool $pool.Name -NumCpuShares $shares -NumMemShares $shares
}