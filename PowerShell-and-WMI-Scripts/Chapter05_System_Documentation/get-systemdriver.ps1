function get-systemdriver {
[CmdletBinding()]
param (
 [parameter(ValueFromPipeline=$true,
   ValueFromPipelineByPropertyName=$true)]
 [string]$computername="$env:COMPUTERNAME"
)  
PROCESS { 
Get-WmiObject -Class Win32_SystemDriver -ComputerName $computername |
sort State, DisplayName |
select DisplayName, State, Status, ServiceType, StartMode, PathName
}
}