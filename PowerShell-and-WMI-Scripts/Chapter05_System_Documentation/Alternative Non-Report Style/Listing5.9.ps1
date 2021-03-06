function get-port {
[CmdletBinding()]
param (
 [parameter(ValueFromPipeline=$true,
   ValueFromPipelineByPropertyName=$true)]
 [string]$computername="$env:COMPUTERNAME"
)  
PROCESS { 
Write-Verbose "Parallel Port"
Get-WmiObject -Class Win32_ParallelPort `
  -ComputerName $computername | 
select Name, OSAutoDiscovered,
PNPDeviceID

Write-Verbose "Serial Port"
Get-WmiObject -Class Win32_SerialPort `
  -ComputerName $computername | 
select Name, OSAutoDiscovered,
PNPDeviceID, ProviderType, MaxBaudRate

 Write-Verbose "USBHub"
 Get-WmiObject -Class Win32_USBHub `
  -ComputerName $computername | 
 select Name, PNPDeviceID
 
 Write-Verbose "`nUSB Controller"
 Get-WmiObject -Class Win32_USBController `
  -ComputerName $computername |  
 Select Name, PNPDeviceID
}
}