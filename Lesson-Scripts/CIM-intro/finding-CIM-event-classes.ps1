<#

    Create a subscription for any new starting service

#>



# First, check if their are any current events and unregister them
Get-EventSubscriber | Unregister-Event



# Create the query
$query = "SELECT * FROM Win32_Service"
$query1= "SELECT * FROM __InstanceModificationEvent WITHIN 1 WHERE TargetInstance ISA 'Win32_Service'"



# Register the event and make the $event global
# This will generate an error as this is not an event class
Register-CimIndicationEvent -Query $query -Action {
    Write-Host -ForegroundColor Cyan "New service being started... $($Event.SourceEventArgs.NewEvent.Name)"
    $Global:ServiceEvent = $Event
}



<#
    Should get an error because the service class does not have an event class


    This will get a list of all CIM event classes
    Get-CimClass -ClassName * -QualifierName Indication

    We will need to use intrinsic events to see these events
    __InstanceCreationEvent
    __InstanceModificationEvent
    __InstanceDeletionEvent

    $Query1 is what we need to use
#>


Register-CimIndicationEvent -Query $query1 -Action {
    $Global:ServiceEvent = $Event
}




#Get-CimInstance -ClassName Win32_Service | gm



# Kill any stopped jobs
Get-Job -State Stopped | Remove-Job 



Get-CimClass -ClassName * -QualifierName Indication