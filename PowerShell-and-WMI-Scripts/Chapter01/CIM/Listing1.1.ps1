##
## Assumes that remote machine is running PowerShell v3
##
# Requires -Version3
"dc02", "W08R2CS01", "W08R2CS02",  "W08R2SQL08", "W08R2SQL08A", "WSS08" | foreach {
    Get-CIMInstance -Class Win32_LogicalDisk -ComputerName $_ -Filter "DeviceId='C:'" } | 
Format-Table SystemName, @{Name="Free"; Expression={[math]::round($($_.FreeSpace/1GB), 2)}} -auto
