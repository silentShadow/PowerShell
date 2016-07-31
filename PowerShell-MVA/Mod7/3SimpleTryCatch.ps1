$Computer='notonline'
Try{
    <#
        you MUST use ErrorAction Stop in order for the Catch block to run
        
    #>
    $os=Get-Wmiobject -ComputerName $Computer -Class Win32_OperatingSystem -ErrorAction Stop -ErrorVariable CurrentError
    
}
Catch{
    Write-warning "You done made a boo-boo with computer $Computer"            
}