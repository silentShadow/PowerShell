$filterName = 'testingFilter' 
$consumerName = 'testingConsumer' 
$exePath = 'C:\Windows\System32\calc.exe' 
$Query = "SELECT * FROM __InstanceModificationEvent WITHIN 60 
                WHERE TargetInstance ISA 'Win32_PerfFormattedData_PerfOS_System' 
                AND TargetInstance.SystemUpTime >= 200 
                AND TargetInstance.SystemUpTime < 320" 

$WMIEventFilter = Set-WmiInstance -Class __EventFilter `
                                  -NameSpace "root\subscription" `
                                  -Arguments @{Name=$filterName
                                               EventNameSpace="root\cimv2"
                                               QueryLanguage="WQL"
                                               Query=$Query
                                               } `
                                  -ErrorAction Stop 

$WMIEventConsumer = Set-WmiInstance -Class CommandLineEventConsumer `
                                    -Namespace "root\subscription" `
                                    -Arguments @{Name=$consumerName
                                                 ExecutablePath=$exePath
                                                 CommandLineTemplate =$exePath
                                                 } 

Set-WmiInstance -Class __FilterToConsumerBinding `
                -Namespace "root\subscription" `
                -Arguments @{Filter=$WMIEventFilter
                             Consumer=$WMIEventConsumer
                             }
