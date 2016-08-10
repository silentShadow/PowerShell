$query = "select * from __instanceCreationEvent within 20 where
                    targetInstance isa 'Win32_logonSession' and
                    targetInstance.LogonType = 2"

$q1 = "select * from __InstanceCreationEvent within 5 where
                targetInstance isa 'Win32_Process'"

$q2 = "select * from win32_process where name='notepad.exe'"

#Get-WmiObject -Query $q2

Get-WMIObject -Namespace root\Subscription -Class __EventFilter | Remove-WmiObject
Get-WmiObject -Namespace root\subscription -Class __eventConsumer | Remove-WmiObject
Get-WmiObject -Namespace root\subscription -Class __filterToConsumerBinding


$filter = New-WmiEventFilter -Name procFilter -Query $q2
$consumer = New-WmiEventConsumer -Name procConsumer -ConsumerType CommandLine -ComputerName $env:COMPUTERNAME -CommandLineTemplate "C:\Windows\System32\calc.exe" -ExecutablePath "C:\Windows\System32\calc.exe"
$binding = New-WmiFilterToConsumerBinding -ComputerName $env:COMPUTERNAME -Filter $filter -Consumer $consumer
