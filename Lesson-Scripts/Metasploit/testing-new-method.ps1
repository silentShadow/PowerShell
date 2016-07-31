$newWMI = @{
    Query = "SELECT * FROM __InstanceCreationEvent WITHIN 1 WHERE TargetInstance ISA 'Win32_Process'"
    Action = {
        if ($Event.SourceEventArgs.NewEvent) {
            $Global:Data = $Event
            Write-Host -Fore Green -Back Black ("Process: {0} is executing from {1} with PID of {2}" -f $event.SourceEventArgs.NewEvent.TargetInstance.Name,
                                                                                                     $event.SourceEventArgs.NewEvent.TargetInstance.ExecutablePath,
                                                                                                     $event.SourceEventArgs.NewEvent.TargetInstance.ProcessId) 
        }
    }

    SourceIdentifier = "ProcessStart"
}


$oldWMI = @{
    Query = "SELECT * FROM Win32_ProcessStopTrace"
    Action = { Write-Host -Fore Red -Back Black ("Process $($event.SourceEventArgs.NewEvent.ProcessName) terminated") }
    SourceIdentifier = "ProcessStop"

}


$newTempDir = @{
    Query = ""
    Action = {}
    SourceIdentifier = "File Creation"
}


$oldTempDir = @{
    Query = ""
    Action = {}
    SourceIdentifier = "File Deletion"
}


$newRegKey = @{
    Query = "SELECT * FROM RegistryKeyChangeEvent WHERE Hive='HKEY_LOCAL_MACHINE' AND KeyPath='SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Run'"
    Action = { 
        $Global:Reg = $event
        Write-Host -Fore Yellow -Back Black "RegKey change for HKLM::Software\Microsoft\CurrentVersion\Run"        
    }
    SourceIdentifier = "Meterpreter RegKey"
}



if (Get-EventSubscriber | where {$_.SourceIdentifier -eq "ProcessStart"  })     { Unregister-Event -SourceIdentifier "ProcessStart"  }
if (Get-EventSubscriber | where {$_.SourceIdentifier -eq "ProcessStop"   })     { Unregister-Event -SourceIdentifier "ProcessStop"   }
if (Get-EventSubscriber | where {$_.SourceIdentifier -eq "File Creation" })     { Unregister-Event -SourceIdentifier "File Creation" }
if (Get-EventSubscriber | where {$_.SourceIdentifier -eq "File Deletion" })     { Unregister-Event -SourceIdentifier "File Deletion" }
if (Get-EventSubscriber | where {$_.SourceIdentifier -eq "Meterpreter RegKey"}) { Unregister-Event -SourceIdentifier "Meterpreter RegKey" }


Register-WMIEvent @newWMI
Register-WmiEvent @oldWMI


Register-WmiEvent @newRegKey


#$Data | gm
#$Data.SourceEventArgs.NewEvent.TargetInstance.Name
#$Data.SourceEventArgs.NewEvent.TargetInstance.ExecutablePath -like "C:\Users\student\AppData\Local\Temp"
#$Data.SourceEventArgs.NewEvent.TargetInstance.ExecutablePath
#$Data.SourceEventArgs.NewEvent.TargetInstance.ProcessId



# Kill any old jobs that are stopped
if (Get-Job | where state -eq stopped){
    $job = Get-Job | where state -eq stopped | select Id
    Write-Host -ForegroundColor Cyan "`nFound and removed a stopped job"
    Get-Job | where state -eq stopped | Remove-Job  
}

else {
    Write-Host -ForegroundColor Cyan "`nNo stopped jobs found"
}
