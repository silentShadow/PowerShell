$today = [datetime]::Today
$yesterday = [datetime]::Today. - 1


[datetime]::Today | gm
[datetime]::Today.DayOfWeek


# Gets all events for today from the application and system logs
Get-WinEvent -FilterHashtable @{ logname='application','system' ; starttime=$today }


# Groups logs by logname and displays total count
Get-WinEvent -FilterHashtable @{ logname='application','system' ; starttime=$today } | Group-Object logname -NoElement


# Show any errors that happened today
Get-WinEvent -FilterHashtable @{ logname='application','system' ; starttime=$today ; level=2 } | Group-Object logname -NoElement
Get-WinEvent -FilterHashtable @{ logname='application','system' ; starttime=$today ; level=2 } | fl -Property id, message


# Newer cmdlet with better functionality
Get-EventLog -LogName * 
Get-EventLog -LogName Application 
Get-EventLog -LogName Application -Newest 10
Get-EventLog -LogName Application -Newest 10 -After 04/25/2016
Get-EventLog -LogName Application -Newest 10 -After 04/25/2016 -EntryType Error
Get-EventLog -LogName HardwareEvents
Get-EventLog -LogName 'Windows PowerShell' -Newest 10 
Get-EventLog -LogName System -UserName NT* | Group-Object -Property UserName -NoElement | ft count, name
