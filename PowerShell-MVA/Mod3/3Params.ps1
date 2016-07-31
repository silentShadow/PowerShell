function testing{

#add the Param block

[CmdletBinding()]  #adds extra features to our parameters
param(
    [String]$ComputerName='localhost',
    [String]$Drive='c:'
)

Get-WmiObject -class Win32_logicalDisk -Filter "DeviceID='$Drive'" -ComputerName $ComputerName

}