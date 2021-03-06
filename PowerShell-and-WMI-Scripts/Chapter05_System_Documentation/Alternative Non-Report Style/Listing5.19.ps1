function get-software {
[CmdletBinding()]
param (
 [parameter(ValueFromPipeline=$true,
   ValueFromPipelineByPropertyName=$true)]
 [string]$computername="$env:COMPUTERNAME"
)
PROCESS {  
Write-Verbose "Installed Software"
 Get-WmiObject -Class Win32_Product `
 -ComputerName $computername | 
 select Name, IdentifyingNumber, 
 InstallLocation, Vendor, Version
 
Write-Verbose "Installed COM Applications" 
 Get-WmiObject -Class Win32_COMApplication `
 -ComputerName $computername |  
select Name, AppID
}
}    