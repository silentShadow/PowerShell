# Define the signature - i.e. __EventFilter
$EventFilterArgs = @{
    EventNamespace = 'root/cimv2'
    Name = 'LateralMovementEvent'
    Query = 'SELECT * FROM MSFT_WmiProvider_ExecMethodAsyncEvent_Pre WHERE ObjectPath="Win32_Process" AND MethodName="Create"'
    QueryLanguage = 'WQL'
}

$InstanceArgs = @{
    Namespace = 'root/subscription'
    Class = '__EventFilter'
    Arguments = $EventFilterArgs
}

$Filter = Set-WmiInstance @InstanceArgs

# Define the event log template and parameters
$Template = @(
    'Lateral movement detected!',
    'Namespace: %Namespace%',
    'Object: %ObjectPath%',
    'Method Executed: %MethodName%',
    'Command Executed: %InputParameters.CommandLine%'
)

$NtEventLogArgs = @{
    Name = 'LogLateralMovementEvent'
    Category = [UInt16] 0
    EventType = [UInt32] 2 # Warning
    EventID = [UInt32] 8
    SourceName = 'WSH'
    NumberOfInsertionStrings = [UInt32] $Template.Length
    InsertionStringTemplates = $Template
}

$InstanceArgs = @{
    Namespace = 'root/subscription'
    Class = 'NTEventLogEventConsumer'
    Arguments = $NtEventLogArgs
}

$Consumer = Set-WmiInstance @InstanceArgs

$FilterConsumerBingingArgs = @{
    Filter = $Filter
    Consumer = $Consumer
}

$InstanceArgs = @{
    Namespace = 'root/subscription'
    Class = '__FilterToConsumerBinding'
    Arguments = $FilterConsumerBingingArgs
}

# Run the following code from an elevated PowerShell console.

# Register the alert
$Binding = Set-WmiInstance @InstanceArgs

# Now, this will automatically generate an event log entry in the Application event log.
Invoke-WmiMethod -Class Win32_Process -Name Create -ArgumentList notepad.exe

# Delete the permanent WMI event subscriptions you just made
<#
Get-WmiObject -Namespace 'root/subscription' -Class '__EventFilter' -Filter 'Name="LateralMovementEvent"' | Remove-WmiObject
Get-WmiObject -Namespace 'root/subscription' -Class 'NTEventLogEventConsumer' -Filter 'Name="LogLateralMovementEvent"' | Remove-WmiObject
Get-WmiObject -Namespace 'root/subscription' -Class '__FilterToConsumerBinding' -Filter 'Filter="__EventFilter.Name=\"LateralMovementEvent\""' | Remove-WmiObject
#>
