$q1 = "SELECT * FROM __InstanceCreationEvent WITHIN 5 WHERE
                TargetInstance ISA 'Win32_Process'"

$q2 = "SELECT * FROM __InstanceCreationEvent WITHIN 5 WHERE
                TargetInstance ISA 'Win32_Process' AND
                TargetInstance.Name='notepad.exe'"


$eventArgs = @{
    EventNameSpace = 'root/cimv2'
    Name = 'testNotepad'
    Query = $q1
    QueryLanguage = 'WQL'
}


$filter = Set-WmiInstance -Namespace root/subscription -Class __EventFilter -Arguments $eventArgs


$commandLineConsumerArgs = @{
    Name = 'LegitConsumerHere'
    #CommandLineTemplate = "powershell.exe -NoP -C `"calc.exe`""
    # This works!!
    CommandLineTemplate = "powershell.exe -NoP -C `"ipconfig | Out-File c:\users\student\desktop\ipconfig.txt -Append`""
}


$consumer = Set-WmiInstance -Namespace root/subscription -Class CommandLineEventConsumer -Arguments $commandLineConsumerArgs


$filterToConsumerArgs = @{
    Filter = $filter
    Consumer = $consumer
}



$filterToConsumerBinding = Set-WmiInstance -Namespace root/subscription -Class __FilterToConsumerBinding -Arguments $filterToConsumerArgs


function Invoke-Cleanup {
    $EventConsumerToCleanup = Get-WmiObject -Namespace root/subscription `
                                            -Class CommandLineEventConsumer `
                                            -Filter "Name='LegitConsumerHere'"
    $eventFilterToCleanup = Get-WmiObject -Namespace root/subscription `
                                          -Class __EventFilter `
                                          -Filter "Name='testCalc'"
    $filterConsumerBindingToCleanup = Get-WmiObject -Namespace root/subscription `
                                                    -Query "REFERENCES OF {$($EventConsumerToCleanup.__RELPATH)} WHERE ResultClass = __FilterToConsumerBinding"

    $filterConsumerBindingToCleanup | Remove-WmiObject
    $EventConsumerToCleanup | Remove-WmiObject
    $eventFilterToCleanup | Remove-WmiObject
}

