##
## Assumes that remote machine is running PowerShell v3
##
# Requires -Version 3
function get-display {
[CmdletBinding()]
param (
 [parameter(ValueFromPipeline=$true,
   ValueFromPipelineByPropertyName=$true)]
 [string]$computername="$env:COMPUTERNAME"
) 
PROCESS { 
 "Monitor"
 Get-CimInstance -ClassName Win32_DesktopMonitor `
 -ComputerName $computername | 
 select Name, Description, DeviceId,
 MonitorManufacturer, MonitorType,
 PixelsPerXLogicalInch,
 PixelsPerYLogicalInch,
 ScreenHeight, ScreenWidth
 
 "Video"
 Get-CimInstance -ClassName Win32_VideoController `
 -ComputerName $computername | 
 select Name, 
 @{Name="RAM(MB)"; Expression={$_.AdapterRAM/1mb}},
 VideoModeDescription,
 CurrentRefreshRate,
 InstalledDisplayDrivers, DriverDate,
 DriverVersion
}
}