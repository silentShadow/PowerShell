##Service change
$WMI = @{
    Query = "select * from __instanceModificationEvent within 5 where targetInstance isa 'win32_Service'"
    Action = {
            If ($Event.SourceEventArgs.NewEvent.PreviousInstance.State -ne $event.SourceEventArgs.NewEvent.TargetInstance.State) {
            $Global:Data = $Event
            Write-Host ("Service: {0}({1}) changed from {2} to {3}" -f $event.SourceEventArgs.NewEvent.TargetInstance.DisplayName,
                                                                       $event.SourceEventArgs.NewEvent.TargetInstance.Name,
                                                                       $event.SourceEventArgs.NewEvent.PreviousInstance.State,
                                                                       $event.SourceEventArgs.NewEvent.TargetInstance.State) -Back Black -Fore Green
            }
    }
    SourceIdentifier = "Service.Action"
}


Register-WMIEvent @WMI