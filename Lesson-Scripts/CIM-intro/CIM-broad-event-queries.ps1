<#

    Event queries using CIM

#>



# Unregister events to avoid confusion
Get-EventSubscriber | Unregister-Event



# Events are represented as indications.  Simply put, a change of state
# Subscribe to an event
Register-CimIndicationEvent -ClassName Win32_ProcessStartTrace -Action {
    # This creates a global scoped var
    # We need to verify the process has started

    <#
        Whenever the event is triggered, assign the object in $Event var to
        ProcessEvent in the global scope. 
    #>
    $Global:ProcessEvent = $Event    
    Write-Host -ForegroundColor Cyan "A new process has started..."
    Write-Host -ForegroundColor DarkCyan "Run `$ProcessEvent.SourceEventArgs.NewEvent to see event"
    
}



#Write-Output $ProcessEvent.SourceEventArgs.NewEvent



# Remove any jobs the event created
Get-Job -State Stopped | Remove-Job