<#
    
    We need to run a filter against every new proc to see
    if it matches the one of our interest.

    Our interest is the notepad process

#>


# First, check if their are any current events and unregister them
Get-EventSubscriber | Unregister-Event



# Make the query... remember the .exe must be included
# To see properties for this class pipe to Get-Member
$query = "SELECT * FROM Win32_ProcessStartTrace WHERE ProcessName='notepad.exe'"


Register-CimIndicationEvent -Query $query -Action {
    Write-Host -ForegroundColor Cyan "New notepad proc started... PID: $($Event.SourceEventArgs.NewEvent.ProcessID)"
}


# Kill any stopped jobs
Get-Job -State Stopped | Remove-Job 