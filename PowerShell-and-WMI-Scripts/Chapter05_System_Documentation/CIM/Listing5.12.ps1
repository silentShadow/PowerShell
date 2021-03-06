##
## Assumes that remote machine is running PowerShell v3
##
# Requires -Version 3
function test-powersource {
[CmdletBinding()]
param (
 [parameter(ValueFromPipeline=$true,
   ValueFromPipelineByPropertyName=$true)]
 [string]$computername="$env:COMPUTERNAME"
)  
PROCESS { 
 $status = Get-CimInstance -Namespace 'root\wmi' -ClassName BatteryStatus `
  -ComputerName $computername 
  
 if ($status.PowerOnLine) {"System on Mains Power"}
 else {"System on Battery Power"}
}
}