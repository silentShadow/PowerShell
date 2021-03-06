function calcfree {                   
param (                      
 $disk
) 
 $free = ($disk.FreeSpace / $disk.Size) * 100
 "{0:F2}" -f $free
}

Get-WmiObject -Class Win32_LogicalDisk | 
select DeviceId, 
@{Name="PercFree"; Expression={calcfree $_}} |
sort perfree -Descending |
Format-Table