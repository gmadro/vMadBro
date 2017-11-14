# Author: Greg Madro
# Site: www.virtualinsanity.com
# Description: Script to validate and set resource pools
# Reference: 

$scriptDir = ((Split-Path ((Get-Variable MyInvocation -Scope 0).Value).MyCommand.Path) + "\")

# Load functions script
. $scriptDir\Set-Pool-functions.ps1

$scriptStart = get-date
$logFile = (".\Set-Pool{0}.log" -f $scriptStart.ToString("MM-dd-yyyy_HHmmss"))

Write-Log "HEADER" $logFile "Start of resource pool validation"

$poolFile = Get-Content .\Set-Pool.json | ConvertFrom-Json

# Loop through each Resource Pool on the vCenter Server
$pools = Get-ResourcePool
ForEach ($pool in $pools){
    If($pool.Name -eq "Resources"){

        # Check for VMs in the default resource pool
        Write-Log "LABEL" $logFile ("Pool: {0}" -f $pool.Name)
        $noPoolVM = get-vm | Where {$_.resourcePool -like "*Resources*"} | Select-Object -expandProperty Name
        if ($noPoolVM){

            Write-Log "WARN" $logFIle "THe following VMs are in the default resource pool:"
            Foreach ($npvm in $noPoolVM){

                Write-Log "WARN" $logFIle $npvm
            }
        }
    }
    else{

        Write-Log "LABEL" $logFile ("Pool: {0}" -f $pool.Name)
        $vmCount = $pool.ExtensionData.vm.count
        $shares = 0
    
        # Check for vms in pool. Bypass pool if empty
        if ($vmCount -ne 0){

            Write-Log "INFO" $logFile ("VM Count: $vmCount")
    
            # Validate that pool exist in JSON config
            foreach ($pf in $poolFile.Pools){
    
                if ($pf.Name -like $pool.Name){
    
                    Write-Log "TRUE" $logFile "Pool exists in configuration."
                    $shares = $pf.Shares
                }
            }
    
            if ($shares -ne 0){
    
                $totalShares = $shares * $vmCount  
            }
            else{
    
                $shares = $poolFile.Pools | Where-Object {$_.Name -eq "Default"} | Select-Object -ExpandProperty Shares
                Write-Log "WARN" $logFile "No valid configuration exists for Pool. Setting shares to default value: $shares"
                $totalShares = $shares * $vmCount
            }
        
            # Change Resource Pool share values
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
            
        }# end vmCount
        else{
    
            if($pool.ExtensionData.resourcePool){
    
                Write-Log "INFO" $logFile "Contains child pools:"
                ForEach($nestPool in $pool.ExtensionData.resourcePool){
                    $nestPool
                    $np = Get-ResourcePool | Select-Object -ExpandProperty ExtensionData |Select-Object Name, VM, MoRef |Where {$_.MoRef -like $nestPool}
                    Write-Log "INFO" $logFIle $np
                    Write-Log "INFO" $logFile $np.Vm.Count
                }
            }
            else{
    
                Write-Log "INFO" $logFile "No VMs in Resource Pool. Bypassing..."
            }
        }
    }#end pool
}#end pools

$scriptEnd = Get-Date
$scriptDur = ($scriptEnd - $scriptStart).TotalSeconds
Write-Log "INFO" $logFile ($scriptDur.toString() + " seconds to complete audit")
Write-Log "HEADER" $logFile "End of resource pool validation"