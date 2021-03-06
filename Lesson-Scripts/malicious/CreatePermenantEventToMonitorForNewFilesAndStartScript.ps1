# -----------------------------------------------------------------------------
# Script: CreatePermenantEventConsumer.ps1
# Author: ed wilson, msft
# Date: 7/13/2012 14:42:09
# Keywords: Scripting Techniques, WMI, Events and Monitoring
# comments: Creates permenant event consumer that monitors a folder for new
# file creation. It then fires a VBS that launches a Windows PowerShell script
# HSG-7-18-2012
# -----------------------------------------------------------------------------
$computer = "edlt"
$filterNS = "root\cimv2"
$wmiNS = "root\subscription"
$query = @"
 Select * from __InstanceCreationEvent within 30 
 where targetInstance isa 'Cim_DirectoryContainsFile' 
 and targetInstance.GroupComponent = 'Win32_Directory.Name="c:\\\\test"'
"@
$filterName = "NewFile"
$scriptFileName = "C:\fso\LaunchPowerShell.vbs"

$filterPath = Set-WmiInstance -Class __EventFilter `
 -ComputerName $computer -Namespace $wmiNS -Arguments `
  @{name=$filterName; EventNameSpace=$filterNS; QueryLanguage="WQL";
    Query=$query}


$consumerPath = Set-WmiInstance -Class ActiveScriptEventConsumer `
 -ComputerName $computer -Namespace $wmiNS `
 -Arguments @{name="CleanupFileNames"; ScriptFileName=$scriptFileName;
  ScriptingEngine="VBScript"}

Set-WmiInstance -Class __FilterToConsumerBinding -ComputerName $computer `
  -Namespace $wmiNS -arguments @{Filter=$filterPath; Consumer=$consumerPath} |
  out-null