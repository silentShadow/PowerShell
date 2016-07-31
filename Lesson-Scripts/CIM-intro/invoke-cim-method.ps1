<#

    Invoking CIM Methods is easy using the Invoke-CimMethod cmdlet

    When using the cmdlet, the -Arguments param values must be given
    in a hash table with a full valid path if the file is not in the
    default executable path

#>


# Use the cmdlet to create a new instance of a Win32_Process, notepad.exe
# 2 methods to accomplish this task
Invoke-CimMethod -ClassName Win32_Process -MethodName "Create" -Arguments @{ CommandLine = "notepad.exe" }
Invoke-CimMethod -ClassName Win32_Process -MethodName "Create" -Arguments @{ CommandLine = "notepad.exe"; CurrentDirectory = "C:\windows\system32" }



# Use the cmdlet to terminate an existing instance of a Win32_Process.. notepad.exe
$q = "SELECT * FROM Win32_Process WHERE Name='notepad.exe'"
Invoke-CimMethod -Query $q -MethodName Terminate

# Other methods
Get-CimInstance -ClassName Win32_Process -Filter "Name='notepad.exe'" | Invoke-CimMethod -MethodName Terminate
