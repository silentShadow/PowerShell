<#
    Problem 1:  Get-Service will tell you if a certain service is running or not.
    It cannot tell you if it should be running.
    You need to compare what is running with what should be running

    Solution is Listing9.1 as well as this function
#>

function get-autoServices {
    [CmdletBinding()]
    param(
        [Parameter(ValueFromPipeline=$true,
                    ValueFromPipelineByPropertyName=$true)]
        [string[]]$computername=$env:COMPUTERNAME,

        [string]$name
    )

    BEGIN{}
    PROCESS{
        # Was there a service name provided
        if (-not $name){
            Write-Verbose -Message "No service name provided; querying all services"
            $cimsvc = Get-CimInstance -ClassName Win32_Service -ComputerName $computername
            #$wmisvc = Get-WmiObject -Class
        }

        else {
            Write-Verbose -Message "Service name provided; querying specific service"
            $cimsvc = Get-CimInstance -ClassName Win32_Service -Filter "Name='$name'" -ComputerName $computername
            #$wmisvc = Get-WmiObject -Class Win32_Service -Filter "Name='$name'" -ComputerName $computername
        }

        # Choose what results are shown
        $cimsvc | select StartMode, 
            State,
            DisplayName, 
            Description       

    }
    END{}
}