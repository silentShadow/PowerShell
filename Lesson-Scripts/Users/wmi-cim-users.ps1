
Get-CimInstance -ClassName Win32_NetworkLoginProfile
Get-CimInstance -ClassName Win32_NetworkLoginProfile -Filter "Caption='student'"
Get-CimInstance -ClassName Win32_NetworkLoginProfile -Filter "Caption='student'" | fl -Property *

Get-CimInstance -ClassName Win32_NetworkLoginProfile | 
    fl -Property Name, LastLogoff, LastLogon, LogonHours, NumberOfLogons,
                 PasswordAge, PrimaryGroupId, Privileges, UserId, UserType, 
                 CimClass, CimInstanceProperties




<#
    Logon Values from the Win32_LogonSession class
#>

$logonValues = DATA { 
ConvertFrom-StringData -StringData @'
       2 = Interactive
       3 = Network
       4 = Batch
       5 = Service
       7 = Unlock
       8 = NetworkCleartext
       9 = NewCredentials
'@
}

$users = Get-CimInstance -ClassName Win32_LogonSession
$users

foreach ( $u in $users ) { $logonValues[ "$($u.LogonType)" ] }
