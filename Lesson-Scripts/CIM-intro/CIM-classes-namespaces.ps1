# Find all classes in the root/WMI namespace that start with win32
Get-CimClass -Namespace root/WMI -ClassName win32*



# List all namespaces 
Get-CimInstance -ClassName __NAMESPACE -Namespace root | select Name



# List all CIM namespaces
function Get-CimNameSpace {
    param(
        $nameSpace = 'root'
    )

    # Query the namespace provided and run foreach over every item
    Get-CimInstance -Namespace $nameSpace -ClassName __NAMESPACE | % {
        # Fancy formatting
        ($ns = '{0}\{1}' -f $nameSpace, $_.Name)
        Get-CimNameSpace $ns
    }
}



# To find what class to use, wildcards can be used for wide searching
Get-CimClass -ClassName win32_proc*



# Gets every instance of the Win32_Process class... basically Get-Process cmdlet
# This cmdlet DOES NOT allow the use of wildcards
Get-CimInstance -ClassName Win32_Process | gm



<#

    Data queries

#>


# You can create filters if you know the property you want to filter
# To see the properties to filter pipe to Get-Member
Get-CimInstance -ClassName Win32_Process -Filter "Name='notepad.exe'"



# Create a query for the filter
$query = "SELECT Name,HandleCount FROM Win32_Process WHERE Name='notepad.exe'"
Get-CimInstance -Query $query 



# How to introduce wildcards in WQLs
# Grab every proc that starts with an 'e'
$query1 = "SELECT * FROM Win32_Process WHERE Name LIKE 'e%'"
Get-CimInstance -Query $query1



# Grab every proc that starts with letters 'j-p'
$query2 = "SELECT * FROM Win32_Process WHERE Name LIKE '[j-p]%'"
Get-CimInstance -Query $query1



