##
## Assumes that remote machine is running PowerShell v3
##
# Requires -Version 3
function get-port {
[CmdletBinding()]
param (
 [parameter(ValueFromPipeline=$true,
   ValueFromPipelineByPropertyName=$true)]
 [string]$computername="$env:COMPUTERNAME"
)  
PROCESS { 
"Parallel Port"
Get-CimInstance -ClassName Win32_ParallelPort `
  -ComputerName $computername | 
select Name, OSAutoDiscovered,
PNPDeviceID

"Serial Port"
Get-CimInstance -ClassName Win32_SerialPort `
  -ComputerName $computername | 
select Name, OSAutoDiscovered,
PNPDeviceID, ProviderType, MaxBaudRate

"USBHub"
 Get-CimInstance -ClassName Win32_USBHub `
  -ComputerName $computername | 
 select Name, PNPDeviceID
 
"`nUSB Controller"
 Get-CimInstance -ClassName Win32_USBController `
  -ComputerName $computername |  
 Select Name, PNPDeviceID
}
}