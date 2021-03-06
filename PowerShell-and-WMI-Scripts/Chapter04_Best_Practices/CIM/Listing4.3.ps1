##
## Assumes that remote machine is running PowerShell v3
##
# Requires -Version 3
function calcfree {                   
param (                      
 $disk
) 
 $free = ($disk.FreeSpace / $disk.Size) * 100
 "{0:F2}" -f $free
}

Get-CimInstance -ClassName Win32_LogicalDisk | 
select DeviceId, 
@{Name="PercFree"; Expression={calcfree $_}} |
sort perfree -Descending |
Format-Table -AutoSize