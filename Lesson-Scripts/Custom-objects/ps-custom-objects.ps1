$newObj = New-Object -TypeName PSCustomObject -Property @{
    "Name"="PowerShell"
    "Version"=5.0
    "Age"=45
}


Write-Output $newObj | gm
Write-Output $newObj