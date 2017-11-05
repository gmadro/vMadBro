<#
.SYNOPSIS
  PowerCLI and JSON
.DESCRIPTION
  Script to show some of the interactions between PowerCLI and JSON
.PARAMETER <Parameter_Name>
    <Brief description of parameter input required. Repeat this attribute if required>
.INPUTS
  <Inputs>
.OUTPUTS
  <Outputs>
.NOTES
  Version:        1.0
  Author:         Greg Madro
  Creation Date:  11/04/2017
  Purpose/Change: Initial script
  
.EXAMPLE
  <Example goes here. Repeat this attribute for more than one example>
#>

$a = Get-Content .\psJSON.json | ConvertFrom-Json
$a.base