#region Scriptblocks that will execute upon alert trigger
$LateralMovementDetected = {
    $Event = $EventArgs.NewEvent

    $EventTime = [DateTime]::FromFileTime($Event.TIME_CREATED)

    $MethodName = $Event.MethodName
    $Namespace = $Event.Namespace
    $Object = $Event.ObjectPath
    $User = $Event.User
    $CommandLine = $Event.InputParameters.CommandLine

    Write-Warning @"
SIGNATURE: Lateral movement attempt

Date/Time: $EventTime
User: $User
Namespace: $Namespace
Object: $Object
Method Executed: $MethodName
Command Executed: $CommandLine
"@
}

$RemoteRegistryOperation = {
    $Event = $EventArgs.NewEvent

    $EventTime = [DateTime]::FromFileTime($Event.TIME_CREATED)

    $MethodName = $Event.MethodName
    $Namespace = $Event.Namespace
    $Object = $Event.ObjectPath
    $User = $Event.User

    Write-Warning @"
SIGNATURE: WMI registry operation attempt

Date/Time: $EventTime
User: $User
Namespace: $Namespace
Object: $Object
Method Executed: $MethodName
Keys/values modified/deleted/created/enumerated: TODO...
"@
}

$StandardPersistenceOperation = {
    $Event = $EventArgs.NewEvent

    $EventTime = [DateTime]::FromFileTime($Event.TIME_CREATED)

    $Name = $Event.TargetInstance.Name
    $Location = $Event.TargetInstance.Location
    $Command = $Event.TargetInstance.Command

    Write-Warning @"
SIGNATURE: Standard persistence

Date/Time: $EventTime
Persistence Location: $Location
Name: $Name
Command: $Command
"@
}

$PSHostProcessStarted = {
    $Event = $EventArgs.NewEvent

    $LoadTime = [DateTime]::FromFileTime($Event.TIME_CREATED)
    $PID = $Event.ProcessID

    # Note: The host process may already have exited by now.
    # This is a better method for catching any PowerShell host process though.
    $ProcInfo = Get-WmiObject -Query "SELECT * FROM Win32_Process WHERE ProcessId=$PID" -ErrorAction SilentlyContinue

    $CommandLine = $ProcInfo.CommandLine
    $ProcessName = $ProcInfo.Name

    Write-Warning @"
SIGNATURE: Host PowerShell process started

Date/Time: $LoadTime
Process ID: $PID
Process Name: $ProcessName
Command Line: $CommandLine
"@
}

$WMIPersistence = {
    $Event = $EventArgs.NewEvent

    $EventTime = [DateTime]::FromFileTime($Event.TIME_CREATED)

    $Binding = $Event.TargetInstance

    $Consumer = Get-WmiObject -Namespace root/subscription -Query "ASSOCIATORS OF {$($Binding.Filter)}"
    $Filter = Get-WmiObject -Namespace root/subscription -Query "ASSOCIATORS OF {$($Binding.Consumer)}"

    $FilterName = $Filter.Name
    $FilterQuery = $Filter.Query

    $ConsumerName = $Consumer.Name
    $ConsumerCommand = $Consumer.CommandLineTemplate

    Write-Warning @"
SIGNATURE: WMI persistence detected

Date/Time: $EventTime
Filter Name: $FilterName
Filter Query: $FilterQuery
Consumer Name: $ConsumerName
Consumer Command Line: $ConsumerCommand
"@
}

$ClassCreated = {
    $Event = $EventArgs.NewEvent

    $EventTime = [DateTime]::FromFileTime($Event.TIME_CREATED)

    $ClassName = $Event.TargetClass.__CLASS

    Write-Warning @"
SIGNATURE: WMI class created

Date/Time: $EventTime
Class Name: $ClassName
"@
}

$ObjectInstanceEnum = {
    $Event = $EventArgs.NewEvent

    $EventTime = [DateTime]::FromFileTime($Event.TIME_CREATED)

    $Global:Foo = $Event

    $ClassName = $Event.ClassName

    Write-Warning @"
SIGNATURE: Process listing detected

Date/Time: $EventTime
Class Name: $ClassName
"@
}
#endregion


#region Alert definitions
# Trigger on executing code via the Win32_Process Create method
$LateralMovementArgs = @{
    Query = 'SELECT * FROM MSFT_WmiProvider_ExecMethodAsyncEvent_Pre WHERE ObjectPath="Win32_Process" AND MethodName="Create"'
    Action = $LateralMovementDetected
    SourceIdentifier = 'LateralMovementDetection'
}

# Trigger on any method invocation on the StdRegProv class
# Note: the following extrinsic classes are great for detecting registry modification but they only detect changes to the HKLM hive:
# RegistryKeyChangeEvent, RegistryTreeChangeEvent, RegistryValueChangeEvent
$RegistryOperationArgs = @{
    Query = 'SELECT * FROM MSFT_WmiProvider_ExecMethodAsyncEvent_Pre WHERE ObjectPath="StdRegProv"'
    Action = $RemoteRegistryOperation
    SourceIdentifier = 'RegistryOperationDetection'
}

# Trigger on any additions to the startup folder or run keys
$StandardPersistenceArgs = @{
    Query = 'SELECT * FROM __InstanceCreationEvent WITHIN 5 Where TargetInstance ISA "Win32_StartupCommand"'
    Action = $StandardPersistenceOperation
    SourceIdentifier = 'StandardPersistenceOperation'
}

# Trigger on any process that loads the PowerShell DLL - System.Management.Automation[.ni].dll
$PSHostProcArgs = @{
    Query = 'SELECT * FROM Win32_ModuleLoadTrace WHERE FileName LIKE "%System.Management.Automation%.dll%"'
    Action = $PSHostProcessStarted
    SourceIdentifier = 'PowerShellHostProcessStarted'
}

# Trigger upon creation of a permanent WMI event subscription - i.e. WMI persistence
$WMIPersistenceArgs = @{
    Query = 'SELECT * FROM __InstanceCreationEvent WITHIN 5 Where TargetInstance ISA "__FilterToConsumerBinding"'
    Action = $WMIPersistence
    SourceIdentifier = 'WMIPersistenceDetection'
    Namespace = 'root/subscription'
}

# Trigger upon creation of a WMI class - TTP of APT28
$ClassCreationArgs = @{
    Query = 'SELECT * FROM __ClassCreationEvent'
    Action = $ClassCreated
    SourceIdentifier = 'ClassCreated'
    Namespace = 'root/cimv2'
}

#Trigger upon process enumeration
$ObjectInstanceEnumArgs = @{
    Query = 'SELECT * FROM MSFT_WmiProvider_CreateInstanceEnumAsyncEvent_Pre WHERE ClassName="Win32_Process"'
    Action = $ObjectInstanceEnum
    SourceIdentifier = 'ObjectEnumeration'
    Namespace = 'root/cimv2'
}
#endregion


#region Alert registration
Register-WmiEvent @LateralMovementArgs
Register-WmiEvent @PSHostProcArgs
Register-WmiEvent @StandardPersistenceArgs
Register-WmiEvent @RegistryOperationArgs
Register-WmiEvent @WMIPersistenceArgs
Register-WmiEvent @ClassCreationArgs
Register-WmiEvent @ObjectInstanceEnumArgs
#endregion
