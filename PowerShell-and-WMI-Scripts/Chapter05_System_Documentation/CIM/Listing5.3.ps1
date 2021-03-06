##
## Assumes that remote machine is running PowerShell v3
##
# Requires -Version 3
$domrole = DATA {
ConvertFrom-StringData -StringData @'
0 = Standalone Workstation 
1 = Member Workstation 
2 = Standalone Server 
3 = Member Server 
4 = Backup Domain Controller 
5 = Primary Domain Controller
'@
}
function get-domainrole {
[CmdletBinding()]
param (
 [parameter(ValueFromPipeline=$true,
   ValueFromPipelineByPropertyName=$true)]
 [string]$computername="$env:COMPUTERNAME"
)  
PROCESS {
  Get-CimInstance -ClassName Win32_ComputerSystem `
  -ComputerName $computername | 
  select Name, Domain,
  @{Name="DomainRole"; 
  Expression={$domrole["$($_.DomainRole)"]}}
}
}  