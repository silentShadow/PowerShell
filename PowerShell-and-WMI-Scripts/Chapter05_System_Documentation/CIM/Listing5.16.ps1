##
## Assumes that remote machine is running PowerShell v3
##
# Requires -Version 3
function get-bootconfig {
[CmdletBinding()]
param (
 [parameter(ValueFromPipeline=$true,
   ValueFromPipelineByPropertyName=$true)]
 [string]$computername="$env:COMPUTERNAME"
) 
PROCESS {  
 Get-CimInstance -ClassName Win32_BootConfiguration `
 -ComputerName $computername |
 select ConfigurationPath, BootDirectory, 
 Caption, LastDrive,
 ScratchDirectory, TempDirectory
}
}