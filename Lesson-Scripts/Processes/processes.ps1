<#
.Synopsis
determine what processes are running

.Description
determine the running processes and kill them if selected

.Remarks
testing the remarks section

.Title
fun with processes

.Author
Jonathan Reiter

.Date
02/10/2016

 

#>

$GetProcs = Get-Process



$GetProcs_w = Get-Process -Name w*



$GetProcs_s = Get-Process -Name s* | where Id -LT 100



Get-Process -Name svchost -OutVariable svchosts



$svchosts.GetType()



$svchosts.Capacity



function Do-It{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $True)][string]$Name,
        [switch]$Kill
    )

    Begin{
        if($Kill){
            Write-Verbose "Killing $Name"
            
        } else{
            Write-Verbose "Kill switch not enabled"
        
        }
    }
    Process{
        if($Kill){
            Try {
                Stop-Process -Name $Name -ErrorAction Stop
            }

            Catch {
                Write-Warning "You did not give a valid process name"
            }
        }
        else{
            Try{
                Get-Process -Name $Name -ErrorAction Stop
                Write-Information "Here is your process"
            }

            Catch{
                Write-Warning "You did not give a valid process name"
            }
        }
    }
    End{}
}