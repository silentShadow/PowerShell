<#


#>


# Get remote classes, filter on the class methods selecting the name, param, qualifiers
Get-CimClass -ComputerName COMP2 -ClassName Win32_Process | 
    select CimClassMethods -ExpandProperty CimClassMethods | 
    select Name,Parameters,Qualifiers | 
    fl 



# Get remote processes selecting the ComputerName, ProcID, Name
# The PSComputerName is the identifier of the remote machine
Get-CimInstance -ClassName Win32_Process -ComputerName COMP2 |
    select PSComputerName,ProcessId,Name



<# 
    Running the above commands against many remote targets will result in increased overhead making
    the process extremely slow.

    Best practice is to create CIM sessions for every remote target
#>



# Create the CIM session and pass it to a param
$CimSession = New-CimSession -ComputerName comp2
Get-CimInstance -ClassName Win32_Service -Filter "Name='WinRM'" -CimSession $CimSession



# Test the two commands to see which one runs faster
Measure-Command -Expression {
    Write-Host -ForegroundColor Red "`nNot using an existing CIM session..."
    Get-CimInstance -ClassName Win32_Service -Filter "Name='WinRM'" -ComputerName comp2
} | select Milliseconds



Measure-Command -Expression {
    Write-Host -ForegroundColor Green "`nUsing an existing CIM session..."
    Get-CimInstance -ClassName Win32_Service -Filter "Name='WinRM'" -CimSession $CimSession
} | select Milliseconds




# View any current CIM sessions
Get-CimSession

# Remove all CIM sessions
Get-CimSession | Remove-CimSession



