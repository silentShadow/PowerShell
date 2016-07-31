Function set-stuff{
<#
    SupportsShouldProcess allows extra functionality like, -WhatIf, -Verbose
#>
    [cmdletbinding(SupportsShouldProcess=$true,
                    confirmImpact='Medium')]

    param(
        [Parameter(Mandatory=$True)]
        [string]$computername   
    )

<#
    the .shouldProcess accepts 2 args: subject[0] and verb[1]
    the subject is what the action is being applied to

    can NOT use .shouldProcess without SupportsShouldProcess
#>
    Process{
        If ($psCmdlet.shouldProcess("$Computername","Destroy the target")){
            Write-Output 'Im changing something right now'
        }
    }
}
