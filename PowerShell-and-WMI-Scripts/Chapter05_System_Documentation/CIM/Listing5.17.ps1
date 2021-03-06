##
## Assumes that remote machine is running PowerShell v3
##
# Requires -Version 3
$dump = DATA {
ConvertFrom-StringData -StringData @'
0 = None 
1 = Complete Memory Dump 
2 = Kernel Memory Dump 
3 = Small Memory Dump
'@
} 

function get-OSrecovery {
[CmdletBinding()]
param (
 [parameter(ValueFromPipeline=$true,
   ValueFromPipelineByPropertyName=$true)]
 [string]$computername="$env:COMPUTERNAME"
) 
PROCESS {   
 Get-CimInstance -ClassName Win32_OSRecoveryConfiguration `
  -ComputerName $computername | 
 select Name, AutoReboot, DebugFilePath,
 @{Name="Debug Info"; 
 Expression={$dump["$($_.DebugInfoType)"]}},
 ExpandedDebugFilePath, ExpandedMiniDumpDirectory,
 KernelDumpOnly, MiniDumpDirectory,
 OverwriteExistingDebugFile,
 SendAdminAlert, WriteDebugInfo,
 WriteToSystemLog
} 
}