$ErrorActionPreference

Get-WmiObject win32_bios -ComputerName localhost,dc

Get-WmiObject win32_bios -ComputerName localhost,dc -EA SilentlyContinue -EV MyError
$MyError

Get-WmiObject win32_bios -ComputerName localhost,dc -EA Stop

Get-WmiObject win32_bios -ComputerName localhost,dc -EA Inquire

<#
    you can find the current error stored in $CurrentError variable

#>