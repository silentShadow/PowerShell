##
## Assumes that remote machine is running PowerShell v3
##
# Requires -Version 3
function get-software {
[CmdletBinding()]
param (
 [parameter(ValueFromPipeline=$true,
   ValueFromPipelineByPropertyName=$true)]
 [string]$computername="$env:COMPUTERNAME"
)
PROCESS {  
"Installed Software"
 Get-CimInstance -ClassName Win32_Product `
 -ComputerName $computername | 
 select Name, IdentifyingNumber, 
 InstallLocation, Vendor, Version
 
"Installed COM Applications" 
 Get-CimInstance -ClassName Win32_COMApplication `
 -ComputerName $computername |  
select Name, AppID
}
}        