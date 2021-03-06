##
## Assumes that remote machine is running PowerShell v3
##
# Requires -Version 3
function get-input {
[CmdletBinding()]
param (
 [parameter(ValueFromPipeline=$true,
   ValueFromPipelineByPropertyName=$true)]
 [string]$computername="$env:COMPUTERNAME"
)  
PROCESS { 
 "Keyboard"
 Get-CimInstance -ClassName Win32_Keyboard `
 -ComputerName $computername | 
 select Name, Description, DeviceId,
 Layout, NumberOfFunctionKeys
 
 "Mouse"
 Get-CimInstance -ClassName Win32_PointingDevice `
 -ComputerName $computername | 
 select Manufacturer, Name, DeviceID,
 DeviceInterface
}
}