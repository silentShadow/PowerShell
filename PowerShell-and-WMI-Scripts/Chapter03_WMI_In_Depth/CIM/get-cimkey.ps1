## Replaces Listing 3.4
## Assumes that remote machine is running PowerShell v3
##
# Requires -Version 3
function get-cimkey {
param (
 [string]$namespace = "root\cimv2",
 [string]$class = "Win32_Service"
)
    Get-CimClass -Namespace $namespace -ClassName $class | 
    select -ExpandProperty properties | 
    foreach { 
     $name = $_.Name
     $_ | select -ExpandProperty Qualifiers |
     foreach { 
       if ($_.Name -eq "Key") {
         Write-Host "Key property of $namespace\$class is $name"
       }
     }
    }
}