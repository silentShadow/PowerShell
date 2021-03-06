##
## Assumes that remote machine is running PowerShell v3
##
# Requires -Version 3
Get-CimInstance -ClassName Win32_ComputerSystem |
Format-List Manufacturer, Model, TotalPhysicalMemory

Get-CimInstance -ClassName Win32_ComputerSystem |
Format-List Manufacturer, Model,
@{Name="RAM(GB)"; Expression={$([math]::round(($_.TotalPhysicalMemory / 1gb),2))}}
