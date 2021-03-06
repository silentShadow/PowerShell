function get-input {
[CmdletBinding()]
param (
 [parameter(ValueFromPipeline=$true,
   ValueFromPipelineByPropertyName=$true)]
 [string]$computername="$env:COMPUTERNAME"
)  
PROCESS { 
 Write-Verbose "Keyboard"
 Get-WmiObject -Class Win32_Keyboard `
 -ComputerName $computername | 
 select Name, Description, DeviceId,
 Layout, NumberOfFunctionKeys
 
 Write-Verbose "Mouse"
 Get-WmiObject Win32_PointingDevice `
 -ComputerName $computername | 
 select Manufacturer, Name, DeviceID,
 DeviceInterface
}
}