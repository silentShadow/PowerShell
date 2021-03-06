##
## Assumes that remote machine is running PowerShell v3
##
# Requires -Version 3
$comptype = DATA {
ConvertFrom-StringData -StringData @'
0 =  Unspecified 
1 =  Desktop 
2 =  Mobile 
3 =  Workstation 
4 =  Enterprise Server 
5 =  Small Office and Home Office (SOHO) Server 
6 =  Appliance PC 
7 =  Performance Server 
8 =  Maximum
'@
}
function get-computertype {
[CmdletBinding()]
param (
 [parameter(ValueFromPipeline=$true,
   ValueFromPipelineByPropertyName=$true)]
 [string]$computername="$env:COMPUTERNAME"
)  
PROCESS {
  Get-CimInstance -ClassName Win32_ComputerSystem `
  -ComputerName $computername | 
  select Name,
  @{Name="ComputerType"; Expression={$comptype["$($_.PCSystemType)"]}}
}  
}