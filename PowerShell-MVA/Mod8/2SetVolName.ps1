function Set-VolLabel
{

<#
    SupportsShouldProcess allows extra functionality like, -WhatIf, -Verbose
#>
    [CmdletBinding(SupportsShouldProcess=$true, 
                   ConfirmImpact='Medium')]
    Param
    (
        [Parameter(Mandatory=$True)]
        [String]$ComputerName,

        [Parameter(Mandatory=$True)]
        [String]$Label
    )

<#
    the .shouldProcess accepts 2 args: subject[0] and verb[1]
    the subject is what the action is being applied to
#>
    Process
    {
        if ($pscmdlet.ShouldProcess("$ComputerName - label change to $Label"))
        {
            $VolName = Get-WmiObject -Class Win32_LogicalDisk -Filter "DeviceID='c:'" -ComputerName $ComputerName 
            $VolName.VolumeName = "$Label"
            $VolName.Put() | Out-Null
        }     
    }
}
