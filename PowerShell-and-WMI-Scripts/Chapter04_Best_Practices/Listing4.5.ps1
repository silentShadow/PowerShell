function test-status {
    Import-Csv "c:\users\student\downloads\scripts\chapter04\computers4.csv" |
    foreach {
          Get-WmiObject -Class Win32_PingStatus -Filter "Address='$($_.Computer)'"
    }
}

function test-status2 {
 [CmdletBinding()]
 param()
    Import-Csv "c:\users\student\downloads\scripts\chapter04\computers4.csv" |
    foreach {
        Write-Debug $_.Computer
        Get-WmiObject -Class Win32_PingStatus -Filter "Address='$($_.Computer)'"
    }
}