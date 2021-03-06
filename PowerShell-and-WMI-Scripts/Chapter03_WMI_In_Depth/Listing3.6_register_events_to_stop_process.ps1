$process = "notepad.exe"
$action = {
  Write-Host "Notepad is running and must be stopped"
  Get-WmiObject -Class Win32_Process -Filter "Name='$process'" |
  Invoke-WmiMethod -Name Terminate
  Write-Host "Notepad has been stopped"
}

# This creates a PShell background job
$WMIQuery = "SELECT * FROM __InstanceCreationEvent WITHIN 5 WHERE TargetInstance ISA 'Win32_Process' AND TargetInstance.Name = '$Process'"

# Register the event so the action can be executed
Register-WmiEvent -Query $WMIQuery -SourceIdentifier "Process $Process" -Action $action

# When finished it is best practice to unregister the event
# Then you can stop the job

#Unregister-Event -SourceIdentifier "Process $process"