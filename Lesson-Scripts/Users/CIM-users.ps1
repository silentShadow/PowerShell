Get-CimClass -ClassName *log*

Get-CimClass -ClassName Win32_LoggedOnUser
Get-CimClass -ClassName Win32_LogonSession

Get-CimInstance -ClassName Win32_LogonSession | gm 
Get-CimInstance -ClassName Win32_LogonSession | select -Property *


Get-CimInstance -ClassName Win32_LoggedOnUser | gm
Get-CimInstance -ClassName Win32_LoggedOnUser | select -Property *

$query = "SELECT * FROM Win32_LoggedOnUser"
Get-CimInstance -Query $query