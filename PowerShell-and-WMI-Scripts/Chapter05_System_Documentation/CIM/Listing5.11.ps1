##
## Assumes that remote machine is running PowerShell v3
##
# Requires -Version 3
function get-batterystatus {
[CmdletBinding()]
param (
 [parameter(ValueFromPipeline=$true,
   ValueFromPipelineByPropertyName=$true)]
 [string]$computername="$env:COMPUTERNAME"
)  
PROCESS { 
 Get-CimInstance -Namespace 'root\wmi' -ClassName BatteryStatus `
  -ComputerName $computername | 
  Select Active, ChargeRate, Charging,
 Critical, DischargeRate, Discharging,
 PowerOnline, RemainingCapacity,
 Tag, Voltage
}
}