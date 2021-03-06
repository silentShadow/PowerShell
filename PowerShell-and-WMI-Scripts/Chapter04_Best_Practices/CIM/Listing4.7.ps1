##
## Assumes that remote machine is running PowerShell v3
##
# Requires -Version 3
Start-Process notepad
Start-Sleep -Seconds 5

$ret = Get-CimInstance -ClassName Win32_Process `
        -Filter "Name='notepad.exe'" | 
       Invoke-CimMethod -MethodName Terminate

if ($ret.ReturnValue -eq 0) {Write-Host "Worked OK"}
else {Write-Host "FAILED"}       