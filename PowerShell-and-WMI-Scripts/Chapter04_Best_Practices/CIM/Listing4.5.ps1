##
## Assumes that remote machine is running PowerShell v3
##
# Requires -Version 3
function test-status {
    Import-Csv computers4.csv |
    foreach {
          Get-CimInstance -ClassName Win32_PingStatus `
           -Filter "Address='$($_.Computer)'"
    }
}

function test-status2 {
 [CmdletBinding()]
 param()
    Import-Csv computers4.csv |
    foreach {
        Write-Debug $_.Computer
        Get-CimInstance -ClassName Win32_PingStatus `
        -Filter "Address='$($_.Computer)'"
    }
}