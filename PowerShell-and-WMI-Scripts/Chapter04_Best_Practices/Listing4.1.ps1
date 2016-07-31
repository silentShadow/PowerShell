function get-ram {
[CmdletBinding()]
param ( 
 [parameter(Mandatory=$true)]
 [string]$computername
) 
 Get-WmiObject -Class Win32_ComputerSystem -ComputerName $computername | 
 Select Name, @{Name="RAM"; Expression={$_.TotalPhysicalMemory / 1GB}} 
}
