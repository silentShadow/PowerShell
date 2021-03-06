##
## Assumes that remote machine is running PowerShell v3
##
# Requires -Version3
$procs = Get-CimInstance -Query "SELECT * FROM Win32_Process"
foreach ($proc in $procs) {
    Write-Host "Name          :" $proc.ProcessName
    Write-Host "Handle        :" $proc.Handle 
    Write-Host "Total Handles :" $proc.Handles
    Write-Host "ThreadCount   :" $proc.ThreadCount
    Write-Host "Path          :" $proc.ExecutablePath           
}