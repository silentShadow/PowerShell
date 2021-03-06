Get-WmiObject -Class Win32_ComputerSystem |
Format-List Manufacturer, Model, TotalPhysicalMemory

Get-WmiObject -Class Win32_ComputerSystem |
Format-List Manufacturer, Model,
@{Name="RAM(GB)"; Expression={$([math]::round(($_.TotalPhysicalMemory / 1gb),2))}}
