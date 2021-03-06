$status = DATA {
ConvertFrom-StringData -StringData @'
1 = Discharging 
2 = On AC. No battery discharge. Not necessarily charging.
3 = Fully Charged 
4 = Low 
5 = Critical
6 = Charging 
7 = Charging and High 
8 = Charging and Low 
9 = Charging and Critical 
10 = Undefined 
11 = Partially Charged
'@
} 

$chem = DATA {
ConvertFrom-StringData -StringData @'
1 = Other 
2 = Unknown 
3 = Lead Acid 
4 = Nickel Cadmium 
5 = Nickel Metal Hydride 
6 = Lithium-ion 
7 = Zinc air 
8 = Lithium Polymer
'@
} 

function get-battery {
[CmdletBinding()]
param (
 [parameter(ValueFromPipeline=$true,
   ValueFromPipelineByPropertyName=$true)]
 [string]$computername="$env:COMPUTERNAME"
)  
PROCESS {
 Get-WmiObject -Class Win32_Battery  `
  -ComputerName $computername | 
 select DeviceID, Name, Description,
 @{Name="Status"; 
  Expression={$status["$($_.BatteryStatus)"]}}, 
  @{Name="Chemistry"; 
  Expression={$chem["$($_.Chemistry)"]}}, 
 @{Name="Voltage(V)"; 
  Expression={$($_.DesignVoltage / 1000)}},   
 @{Name="PecentChargeLeft"; 
  Expression={$($_.EstimatedChargeRemaining)}},
 PowerManagementSupport
}
}

get-battery