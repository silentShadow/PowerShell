##
## Assumes that remote machine is running PowerShell v3
##
# Requires -Version3
Get-CimInstance -ClassName Win32_Process | 
Format-Table ProcessName, Handle, Handles, 
ThreadCount, ExecutablePath -AutoSize 
