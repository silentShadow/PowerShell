function get-batterystatus {
[CmdletBinding()]
param (
 [parameter(ValueFromPipeline=$true,
   ValueFromPipelineByPropertyName=$true)]
 [string]$computername="$env:COMPUTERNAME"
)  
PROCESS { 
 Get-WmiObject -Namespace 'root\wmi' -Class BatteryStatus `
  -ComputerName $computername | 
  Select Active, ChargeRate, Charging,
 Critical, DischargeRate, Discharging,
 PowerOnline, RemainingCapacity,
 Tag, Voltage
}
}

get-batterystatus