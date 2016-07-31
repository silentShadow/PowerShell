

<#
.SYNOPSIS
Aid in detection of metasploit payload binaries

.DESCRIPTION
This cmdlet should greatly increase the awareness of possible metasploit binaries

.EXAMPLE

#>
function Get-Filez {
    param ($e)
        $time = $e.TimeGenerated     # what time
     
        if (!($e.SourceIdentifier -eq "modfiles")){
            
            $pc = $e.SourceEventArgs.NewEvent.TargetInstance.PartComponent 
            $data = $pc -split "="
            $file = $data[1].Replace("\\","\").Replace("""","")
         }
     
         else {
            $file = $e.SourceEventArgs.NewEvent.PreviousInstance.Name
         }
 
     switch ($e.SourceIdentifier) {
        "newfiles" {Write-Host -ForegroundColor Cyan "$time : File $file has been created"; break}
        "delfiles" {Write-Host -ForegroundColor Red "$time : File $file has been deleted"; break}
     }
}




<#
    This function is for taking action on the instance of new files being created
#>
function Show-BalloonTip {
 
    [CmdletBinding(SupportsShouldProcess = $true)]
        param(
            [Parameter(Mandatory=$true,
                       Position=0)]
            $Text="Welcome to Extreme PowerShell!!",
   
            [Parameter(Mandatory=$true,
                       Position=1)]
            $Title="Extreme PShell",

            [Parameter(Mandatory=$false,
                       Position=2)]
            [ValidateSet($true, $false)]
            $Visible=$true,
   
            [ValidateSet('None', 'Info', 'Warning', 'Error')]
            $Icon = 'Info',

            $Timeout = 10000
        )
 
        Add-Type -AssemblyName System.Windows.Forms

        if ($script:balloon -eq $null) {
            $script:balloon = New-Object System.Windows.Forms.NotifyIcon
    
        }

        $path                    = Get-Process -id $pid | Select-Object -ExpandProperty Path
        $balloon.Icon            = [System.Drawing.Icon]::ExtractAssociatedIcon($path)
        $balloon.BalloonTipIcon  = $Icon
        $balloon.BalloonTipText  = $Text
        $balloon.BalloonTipTitle = $Title
        $balloon.Visible         = $Visible

        $balloon.ShowBalloonTip($Timeout)
}





function Find-Metasploit {
  param ($e)
   # Defining the event handler
   #$test = $e.SourceEventArgs.NewEvent
   #Write-Host -ForegroundColor Green $test
   #$test | gm | Out-GridView

   $path = $e.SourceEventArgs.NewEvent.__PATH
   Write-Host -ForegroundColor Green $path

   $proc = $e.SourceEventArgs.NewEvent.ProcessName
   $MeterpreterFileName = "[a-z]{8}"
   
   # Check to see if the proc is starting/stopping
   # Starting procs are evaluated here we are looking for any file matching our regex
   if ($e.SourceIdentifier -eq "Process Start") {
      Write-Host -ForegroundColor Cyan "$proc has started"

      if ($proc -cmatch $MeterpreterFileName) {
        Write-Host -ForegroundColor Yellow "$proc could be a metasploit process"

        Show-BalloonTip -Title "Suspicious File" -Text "$proc has been detected as a suspicious file... Trying to remove it." -Icon Warning

        try{
            Get-WmiObject -Class Win32_Process -Filter $proc | Remove-WmiObject -ErrorAction Stop -ErrorVariable $CustomError
        }
        catch{
            Write-Error $CustomError
        }
      }
   }
   
   # Stopping procs are evald here where it is looking for Calc
   else {
      Write-Host -ForegroundColor Cyan "$proc has stopped"
     } 

}



function Find-Persistence {
    param ($e)
        $time = $e.TimeGenerated     # what time
        
        $pc = $e.SourceEventArgs.NewEvent.TargetInstance.PartComponent 
        $data = $pc -split "="
        $file = $data[1].Replace("\\","\").Replace("""","")

        Write-Host -ForegroundColor Cyan "File $file was created"

        if( (Get-Item -Path $file).Extension -eq ".vbs" -and (Get-Item -Path $file).BaseName -cmatch "[a-zA-z]{8}") {
            Write-Host -ForegroundColor Red "Possible persistence file found!!!"

            Show-BalloonTip -Title "Possible Persistence" -Text "$file is a possible persistence file... Trying to remove it" -Icon Warning

            try{
                Remove-Item -Path $file -Force -Verbose -ErrorAction Stop -ErrorVariable $CustomError
            }
            catch{
                Write-Error -Message $CustomError
            }
        }
}


# for filesystem
if (Get-EventSubscriber |  where {$_.SourceIdentifier -eq "newfiles"}) { Unregister-Event -SourceIdentifier "newfiles" }
if (Get-EventSubscriber |  where {$_.SourceIdentifier -eq "delfiles"}) { Unregister-Event -SourceIdentifier "delfiles" }
if (Get-EventSubscriber |  where {$_.SourceIdentifier -eq "metasploit"}) { Unregister-Event -SourceIdentifier "metasploit" }

# for metasploit
if (Get-EventSubscriber |  where {$_.SourceIdentifier -eq "Process Start"}) { Unregister-Event -SourceIdentifier "Process Start" }
if (Get-EventSubscriber |  where {$_.SourceIdentifier -eq "Process Stop"}) { Unregister-Event -SourceIdentifier "Process Stop" }



# for filesystem
#$nquery = "SELECT * FROM __InstanceCreationEvent WITHIN 5 WHERE TargetInstance ISA 'CIM_DirectoryContainsFile' AND TargetInstance.GroupComponent = 'Win32_Directory.Name=""C:\\\\Windows""'"
#$dquery = "SELECT * FROM __InstanceDeletionEvent WITHIN 5 WHERE TargetInstance ISA 'CIM_DirectoryContainsFile' AND TargetInstance.GroupComponent = 'Win32_Directory.Name=""C:\\\\Windows""'"

# for metasploit
$queryStart = "SELECT * FROM Win32_ProcessStartTrace"
$queryStop = "SELECT * FROM Win32_ProcessStopTrace"

# for persistence
$MeterpreterPersist = "SELECT * FROM __InstanceCreationEvent WITHIN 5 WHERE TargetInstance ISA 'CIM_DirectoryContainsFile' AND TargetInstance.GroupComponent = 'Win32_Directory.Name=""C:\\\\Windows\\\\Temp""'"



$fileAction = {Get-Filez $($event)}            # for the filesystem
$procAction = {Find-Metasploit $($event)}      # for the procs
$persist    = {Find-Persistence $($event)}     # For the persistence


# Events for the filesystem
#Register-WmiEvent -Query $nquery -SourceIdentifier "newfiles" -Action $fileAction
#Register-WmiEvent -Query $dquery -SourceIdentifier "delfiles" -Action $fileAction
Register-WmiEvent -Query $MeterpreterPersist -SourceIdentifier "metasploit" -Action $persist

# Events for the processes
Register-WmiEvent -Query $queryStart -SourceIdentifier "Process Start" -Action $procAction
Register-WmiEvent -Query $queryStop -SourceIdentifier "Process Stop" -Action $procAction



# Kill any old jobs that are stopped
if (Get-Job | where state -eq stopped){
    $job = Get-Job | where state -eq stopped | select Id
    
    Write-Host -ForegroundColor Cyan "`nFound and removed a stopped job"
    
    Get-Job | where state -eq stopped | Remove-Job  
}

else {
    Write-Host -ForegroundColor Cyan "`nNo stopped jobs found"
}