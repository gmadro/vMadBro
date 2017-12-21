$here = (Split-Path -Parent $MyInvocation.MyCommand.Path) -split ('Tests')
Write-Output $here
$script = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
Write-Output $script
. $here\$script

Describe 'Log Insight Tests'{
    It 'Script Exists'{
        $script | Should -Exist
    }
    It 'Calls Send-LogInsight'{
        Send-LogInsight -eventType 'WARN' -eventID '200' -eventMsg 'Inject Test 100' -LIserver 'loginsight.vmadbro.com' -scriptName $script
    }
}
