$EventFilterArgs = @{
    EventNamespace = 'root/cimv2'
    Name = 'PowerShellProcessStarted'
    Query = 'SELECT FileName, ProcessID FROM Win32_ModuleLoadTrace WHERE FileName LIKE "%System.Management.Automation%.dll"'
    QueryLanguage = 'WQL'
}

$Filter = New-CimInstance -Namespace root/subscription -ClassName __EventFilter -Property $EventFilterArgs

$CommandLineConsumerArgs = @{
    Name = 'PowershellMemoryCapture'
    CommandLineTemplate = 'procdump.exe -accepteula -g -e -t -ma %ProcessID% C:\dumps'
}

$Consumer = New-CimInstance -Namespace root/subscription -ClassName CommandLineEventConsumer -Property $CommandLineConsumerArgs

$FilterToConsumerArgs = @{
    Filter = [Ref] $Filter
    Consumer = [Ref] $Consumer
}

$FilterToConsumerBinding = New-CimInstance -Namespace root/subscription -ClassName __FilterToConsumerBinding -Property $FilterToConsumerArgs

<# Cleanup
Get-CimInstance -Namespace root/subscription -ClassName __EventFilter | Remove-CimInstance
Get-CimInstance -Namespace root/subscription -ClassName __EventConsumer | Remove-CimInstance
Get-CimInstance -Namespace root/subscription -ClassName __FilterToConsumerBinding | Remove-CimInstance
#>