Get-CimInstance -ClassName Win32_NetworkAdapter -Filter "DeviceID=1" | fl -Property *
Get-CimInstance -ClassName Win32_NetworkAdapter -Filter "DeviceID=1" | 
    fl -Property CimClass, CimInstanceProperties,
                 Name, NetConnectionID, NetEnabled, MACAddress, 
                 Speed



Get-CimInstance -ClassName Win32_NetworkAdapterConfiguration 
Get-CimInstance -ClassName Win32_NetworkAdapterConfiguration -Filter "Index=1" | fl *
Get-CimInstance -ClassName Win32_NetworkAdapterConfiguration -Filter "Index=1" | 
    fl -Property DNSHostName, DHCPServer, IPAddress, IPSubnet, MACAddress, 
                 CimClass, CimInstanceProperties


