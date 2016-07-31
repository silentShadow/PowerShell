<#
.SYNOPSIS
Finds odd numbers in a given range

.DESCRIPTION
Given a range of numbers, this script will print out
the odd numbers to the console

#>


function Get-OddNumbers {
    [CmdletBinding()]
        param(
            [int]
            $initialValue,
        
            [int]
            $conditionValue
        )

        $range = $initialValue..$conditionValue

        foreach($i in $range){
            if ($i % 2 -eq 0){
                continue
            }
            Write-Host -ForegroundColor Yellow "Found odd number: $i"
        }
}