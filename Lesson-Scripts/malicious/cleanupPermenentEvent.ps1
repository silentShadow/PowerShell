#cleanupPermenentEvent.ps1
gwmi __eventFilter -namespace root\subscription -filter "name='NewFile'"| Remove-WmiObject
gwmi activeScriptEventConsumer -Namespace root\subscription | Remove-WmiObject
gwmi __filtertoconsumerbinding -Namespace root\subscription -Filter "Filter = ""__eventfilter.name='NewFile'"""  | Remove-WmiObject