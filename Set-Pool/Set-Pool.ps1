# Author: Greg Madro
# Site: www.virtualinsanity.com
# Description: Script to validate and set resource pools
# Reference: http://virtualinsanity.com/index.php/2017/11/15/what-do-you-mean-share-resources/

$scriptDir = ((Split-Path ((Get-Variable MyInvocation -Scope 0).Value).MyCommand.Path) + "\")

# Load functions script
. $scriptDir\Set-Pool-functions.ps1

$scriptStart = get-date
$logFile = (".\Set-Pool{0}.log" -f $scriptStart.ToString("MM-dd-yyyy_HHmmss"))

Write-Log "HEADER" $logFile "Start of resource pool validation"

# Load configuration JSON containing desired share values for all resource pools
$poolFile = Get-Content .\Set-Pool.json | ConvertFrom-Json

# Loop through each Resource Pool on the vCenter Server
$pools = Get-ResourcePool
ForEach ($pool in $pools){

    If($pool.Name -eq "Resources"){

        # Check for VMs in the default resource pool
        Write-Log "LABEL" $logFile ("Pool: {0}" -f $pool.Name)
        $noPoolVM = get-vm | Where {$_.resourcePool -like "*Resources*"} | Select-Object -expandProperty Name
        if ($noPoolVM){

            Write-Log "WARN" $logFIle "The following VMs are in the default resource pool:"
            Foreach ($npvm in $noPoolVM){

                Write-Log "WARN" $logFIle $npvm
            }
        }
    }
    else{

        Write-Log "LABEL" $logFile ("Pool: {0}" -f $pool.Name)
        $vmCount = $pool.ExtensionData.vm.count
        $shares = 0

        # Validate that pool exists in JSON config
        foreach ($pf in $poolFile.Pools){

            if ($pf.Name -like $pool.Name){

                Write-Log "TRUE" $logFile "Pool exists in configuration."
                $shares = $pf.Shares
            }
        }
    
        # Check for vms in pool and no child pools
        if ($vmCount -ne 0 -and -not $pool.ExtensionData.resourcePool){

            Write-Log "INFO" $logFile ("VM Count: $vmCount")
    
            $totalShares = 0
    
            if ($shares -ne 0){
    
                $totalShares = [int]$shares * [int]$vmCount
            }
            else{
    
                $shares = $poolFile.Pools | Where {$_.Name -eq "Default"} | Select-Object -ExpandProperty Shares
                Write-Log "WARN" $logFile "No valid configuration exists for Pool. Setting shares to default value: $shares"
                # Calculate pool shares
                $totalShares = [int]$shares * [int]$vmCount
            }    
        }# End vmCount
        else{
            
            # Check for child pools
            if($pool.ExtensionData.resourcePool){
                $parentPool = 0
    
                Write-Log "INFO" $logFile "Contains child pools:"
                ForEach($nestPool in $pool.ExtensionData.resourcePool){
                    $np = Get-ResourcePool | Select-Object -ExpandProperty ExtensionData |Select-Object Name, VM, MoRef |Where {$_.MoRef -like $nestPool}
                    Write-Log "INFO" $logFIle $np.Name
                    Write-Log "INFO" $logFile ("VM Count: {0}" -f $np.Vm.Count)
                    $parentPool += [int]$np.VM.Count
                }
                $totalVM = $parentPool + [int]$pool.ExtensionData.vm.count
                # Calculate pool shares
                $totalShares = $totalVM * $shares
            }
            else{
    
                # If no VMs or children are present bypass the Pool
                Write-Log "INFO" $logFile "No VMs in Resource Pool. Bypassing..."
            }
        }

        # Attmept to change the Resource Pool share values
        try{
            
            $oldShares = $pool.NumCpuShares
            if($oldShares -eq $totalShares -and $oldShares -eq $totalShares){

                Write-Log "INFO" $logFile "Pool shares unchanged from: $oldShares"
            }
            else{
    
                Set-ResourcePool -ResourcePool $pool.Name -NumCpuShares $totalShares -NumMemShares $totalShares
                Write-Log "INFO" $logFile "Pool shares changed from: $oldShares to: $totalShares"
            }
        }
        Catch{

            Write-Log "ERROR" $logFile "Unable to set pool shares"
            Write-Log "ERROR" $logFile $_
        }
    }# End pool
}# End pools

$scriptEnd = Get-Date
$scriptDur = ($scriptEnd - $scriptStart).TotalSeconds
Write-Log "INFO" $logFile ($scriptDur.toString() + " seconds to complete audit")
Write-Log "HEADER" $logFile "End of resource pool validation"
