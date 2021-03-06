##
## Assumes that remote machine is running PowerShell v3
##
# Requires -Version 3
function get-hf {
[CmdletBinding()]
param (
 [parameter(ValueFromPipeline=$true,
   ValueFromPipelineByPropertyName=$true)]
 [string]$computername="$env:COMPUTERNAME"
) 
PROCESS { 
if ($psversiontable.PSversion.Major -ge 2) {
 $fixes = Get-HotFix -ComputerName $computername }
 else {
  $fixes = Get-CimInstance -ClassName Win32_QuickFixEngineering `
    -ComputerName $computer 
 }
 
 $fixes | select CSName, HotFixID, Caption,
 Description, InstalledOn, InstalledBy
}
} 