function Send-LogInsight{
      <#
      .SYNOPSIS
      Send an event to specified Log Insight server.
      
      .DESCRIPTION
      Send an event to log insight and get a return on failure or success
      
      .PARAMETER eventType
      Event type: INFO, WARNING, ERROR

      .PARAMETER eventID
      Event identifier
      
      .PARAMETER eventMsg
      Event body
      
      .PARAMETER LIserver
      Log Insight server to send event entry to

      .PARAMETER scriptName
      Current script name 
      
      .EXAMPLE
      Send-LogInsight -eventType "INFO" -eventMsg "This is an event" -LIserver loginsight.vmadbro.com
      
      .NOTES
      N/A
      #>

      param(
            $eventType,
            $eventID,
            $eventMsg,
            $LIserver,
            $scriptName         
      )

      $agentID = $env:COMPUTERNAME

      $restBody = @{
            events = ([Object[]]([ordered]@{
                  text = $eventMsg
                  fields = @(
                        [ordered]@{
                              name = 'eventType'
                              content = $eventType
                        },
                        [ordered]@{
                              name = 'eventID'
                              content = $eventID
                        },
                        [ordered]@{
                              name = 'agentID'
                              content = $agentID
                        },
                        [ordered]@{
                              name = 'scriptName'
                              content = $scriptName
                        }
                  )
            }))
      } | convertto-json -Depth 4

      $restUrl = ("http://" + $LIserver + ":9000/api/v1/events/ingest/" + $agentID)
      Write-Output ("Posting results to Log Insight server: " + $LIserver)

      try {
            $response = Invoke-RestMethod $restUrl -Method Post -Body $restBody -ContentType 'application/json' -ErrorAction stop
            Write-Output 'REST Call to Log Insight server successful'
            Write-Output $response
      }
      catch {
            Write-Error 'REST Call failed to Log Insight server'
            Write-Warning $_
      }
}

$LIserver = "loginsight.vmadbro.com"
$eventType = "ERROR"
$eventMsg = "Error this does not work"
$eventID = "101"
$scriptName = $MyInvocation.InvocationName.Split('\')[1]
write-host $scriptName

Send-LogInsight -eventType $eventType -eventID $eventID -eventMsg $eventMsg -LIserver $LIserver -scriptName $scriptName
