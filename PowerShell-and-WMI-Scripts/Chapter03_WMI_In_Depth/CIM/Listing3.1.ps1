##
## Assumes that remote machine is running PowerShell v3
##
# Requires -Version 3
function get-namespace {
param ([string]$name)
     Get-CimInstance -Namespace $name -ClassName "__NAMESPACE" | 
     foreach {
        "$name\" + $_.Name
        get-namespace $("$name\" + $_.Name)
     }
}
"root"
get-namespace "root"
