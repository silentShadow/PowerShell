# Another way to create events and filters
#help New-CimInstance -Full
#help Set-CimInstance -Full
#help Get-CimInstance -Full

Get-WMIObject -Namespace root\Subscription -Class __EventFilter
Get-WMIObject -Namespace root\Subscription -Class __EventFilter | Remove-WmiObject
Get-WMIObject -Namespace root\Subscription -Class __EventFilter -Filter "Name='ProcessFilter'" | Remove-WmiObject

Get-WMIObject -Namespace root\Subscription -Class LogFileEventConsumer
Get-WMIObject -Namespace root\Subscription -Class LogFileEventConsumer | Remove-WmiObject
Get-WMIObject -Namespace root\Subscription -Class LogFileEventConsumer -Filter "Name='ProcessConsumer'" | Remove-WmiObject

Get-WMIObject -Namespace root\Subscription -Class CommandLineEventConsumer
Get-WMIObject -Namespace root\Subscription -Class CommandLineEventConsumer | Remove-WmiObject

Get-WMIObject -Namespace root\Subscription -Class __FilterToConsumerBinding
Get-WMIObject -Namespace root\Subscription -Class __FilterToConsumerBinding | Remove-WmiObject



# CIM Params
$WMIparams = @{
    ComputerName = "$env:COMPUTERNAME"  # could use remote IP/NetBios name
    ErrorAction = "Stop"
    NameSpace = "root\subscription"

}



# Create the filter
$WMIparams.Class = "__EventFilter"
$WMIparams.Arguments = @{
    Name = "ProcFilter"
    EventNameSpace = "root\cimv2"
    QueryLanguage = "WQL"
    Query = "SELECT * FROM __InstanceCreationEvent WITHIN 5 WHERE 
                        TargetInstance ISA 'Win32_Process' AND
                        TargetInstance.ProcessName='notepad.exe'"

}


$filterResult = Set-WmiInstance @WMIparams



# Create the consumer
$WMIparams.Class = "LogFileEventConsumer"
$WMIparams.Arguments = @{
    Name = "ProcConsumer"
    Text = "New proc started: %TargetInstance.Name%"
    FileName = "\\Comp112\C:\Users\student\Desktop\processes.log"

}


$consumeResult = Set-WmiInstance @WMIparams


# Create the binding
$WMIparams.Class = "__FilterToConsumerBinding"
$WMIparams.Arguments = @{
    Filter = $filterResult
    Consumer = $consumeResult

}

    
$bindResult = Set-WmiInstance @WMIparams



##Removing WMI Subscriptions using [wmi] and Delete() Method
([wmi]$filterResult).Delete()
([wmi]$consumeResult).Delete()
([wmi]$bindResult).Delete()

Remove-Variable $filterResult
Remove-Variable $consumeResult
Remove-Variable $bindResult