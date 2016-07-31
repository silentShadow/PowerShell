#Choose values to replace with variables

#Make some parameters

param(
    [String]$ComputerName='localhost',
    [String]$Drive='c:'
)

Get-WmiObject -class Win32_logicalDisk -Filter "DeviceID='$Drive'" -ComputerName $ComputerName

