#$xmlservices = Get-Service | select status,name,displayname | Export-Clixml "C:\Users\student\Desktop\xml_svc.xml"
#Import-Clixml "C:\Users\student\Desktop\xml_svc.xml" | ft -AutoSize -Wrap

$services = Get-Service

foreach($svc in $services){
    if($svc.status -eq "Stopped"){
        Write-Host -ForegroundColor Red "$($svc.DisplayName) is stopped"
    }
    else{
        Write-Host -ForegroundColor Green "$($svc.DisplayName) is running"
    }
}
