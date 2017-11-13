function Write-Log{
    Param(
        $logType,
        $logFile,
        $logMessage,
        [switch]$logNoCLI
    )

    $timeStamp = Get-Date -UFormat "%Y%m%d_%H%M%S%Z"
    
    #Check for CLI output supression
    If(-not $logNoCLI){
        switch ($logType){
            'BASE'{
                Write-Host $logMessage
            }
            'INFO'{
                Write-Host $logMessage -ForegroundColor Cyan
            }
            'WARN'{
                Write-Host $logMessage -ForegroundColor Yellow
            }
            'ERROR'{
                Write-Host $logMessage -ForegroundColor Red
            }
            'TRUE'{
                Write-Host $logMessage -ForegroundColor Green
            }
            'LABEL'{
                Write-Host $logMessage -ForegroundColor Blue
            }
            'HEADER'{
                Write-Host $logMessage -ForegroundColor Magenta
            }
        }     
    }

    #Write to log
    "$timeStamp $logType $logMessage" | Out-File -FilePath $logFile -Append
}