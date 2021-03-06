##
## Assumes that remote machine is running PowerShell v3
##
# Requires -Version 3
$process = "calc.exe"
$action = {
  Write-Host "Calculator is running and must be stopped"
  Get-CimInstance -ClassName Win32_Process -Filter "Name='$process'" |
  Invoke-CimMethod -MethodName Terminate
  Write-Host "Calculator is has been stopped"
}

$WMIQuery = "SELECT * FROM __InstanceCreationEvent WITHIN 5 WHERE TargetInstance ISA 'Win32_Process' AND TargetInstance.Name = '$Process'"
Register-CimIndicationEvent -Query $WMIQuery -SourceIdentifier "Process $Process" -Action $action