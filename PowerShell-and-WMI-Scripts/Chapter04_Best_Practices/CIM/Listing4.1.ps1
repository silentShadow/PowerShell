##
## Assumes that remote machine is running PowerShell v3
##
# Requires -Version 3
function get-ram {
[CmdletBinding()]
param ( 
 [parameter(Mandatory=$true)]
 [string]$computername
) 
 Get-CimInstance -ClassName Win32_ComputerSystem -ComputerName $computername | 
 Select Name, @{Name="RAM"; Expression={$_.TotalPhysicalMemory / 1GB}} 
}
