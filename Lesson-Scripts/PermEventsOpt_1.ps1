# List any Event Filters
Get-WMIObject -Namespace root\Subscription -Class __EventFilter


# List event Consumers
Get-WMIObject -Namespace root\Subscription -Class __EventConsumer


# List any Bindings
Get-WMIObject -Namespace root\Subscription -Class __FilterToConsumerBinding


# Creating a new event filter
$instanceFilter = ([wmiclass]"\\.\root\subscription:__EventFilter").CreateInstance()


# Change the properties of the object
$instanceFilter.QueryLanguage = "WQL"
$instanceFilter.Query = "select * from __instanceCreationEvent within 5 where targetInstance isa 'Win32_Process'"
$instanceFilter.Name = "Process Filter"
$instanceFilter.EventNamespace = "root\cimv2"


# View the properties and methods of the object
$instanceFilter | gm -View All
$instanceFilter | gm -MemberType Methods -View All


# Save the filter
$result = $instanceFilter.Put()


# Save the file path of the filter for the consumer
$newFilter = $result.Path
$newFilter


# Create the consumer
$instanceConsumer = ([wmiclass]"\\.\root\subscription:LogFileEventConsumer").CreateInstance()


# Change the properties of the consumer object
$instanceConsumer.Name = 'ProcessConsumer'
$instanceConsumer.Filename = "C:\users\student\desktop\Log.log"
$instanceConsumer.Text = 'A change has occurred on the service: %TargetInstance.Name%'


# Save the object
$consumerResult = $instanceConsumer.Put()
$consumerPath = $consumerResult.Path
$consumerPath


# Bind filter and consumer
$instanceBinding = ([wmiclass]"\\.\root\subscription:__FilterToConsumerBinding").CreateInstance()


# Change the binding properties
$instanceBinding.Filter = $newFilter
$instanceBinding.Consumer = $instanceConsumer


# Save the object
$bindingResult = $instanceBinding.Put()


# Save the path in order to delete the binding in the future
$newBinding = $bindingResult.Path
$newBinding


##Removing WMI Subscriptions using [wmi] and Delete() Method
([wmi]$newFilter).Delete()
([wmi]$consumerPath).Delete()
([wmi]$newBinding).Delete()


# Start a process
([wmiclass]'win32_process').GetMethodParameters('create')
([wmiclass]'win32_process') | gm -View All

Invoke-WmiMethod -Path win32_process -Name create -ArgumentList notepad.exe



