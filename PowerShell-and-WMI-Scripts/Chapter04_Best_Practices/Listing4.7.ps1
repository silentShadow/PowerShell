Start-Process notepad
Start-Sleep -Seconds 5

$ret = Get-WmiObject -Class Win32_Process `
        -Filter "Name='notepad.exe'" | 
       Invoke-WmiMethod -Name Terminate

if ($ret.ReturnValue -eq 0) {Write-Host "Worked OK"}
else {Write-Host "FAILED"}       