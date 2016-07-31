help Get-NetAdapter -Full

Get-NetAdapter -Name * 
Get-NetAdapter -Name Ethernet0 | fl -Property *
Get-NetAdapter -Name Ethernet0 | 
    fl -Property CimClass, CimInstanceProperties, 
                 DriverName, DriverDate, DriverProvider, DriverVersionString,
                 Name, MacAddress, Status, LinkSpeed, MediaConnectionState


help Set-NetAdapter -Full
Set-NetAdapter -Name Ethernet0 -MacAddress "00-11-22-33-44-55"







help Get-NetAdapterAdvancedProperty -Full
Get-NetAdapterAdvancedProperty -AllProperties -Name Ethernet0 | fl -Property *
Get-NetAdapterAdvancedProperty -Name Ethernet0 |
    fl -Property CimClass, CimInstanceProperties, ValueName, 
                 RegistryKeyword, RegistryValue,
                 ValidDisplayValues, ValidRegistryValues


help Set-NetAdapterAdvancedProperty -Full











help Get-NetAdapterHardwareInfo -Full
Get-NetAdapterHardwareInfo -Name *
Get-NetAdapterHardwareInfo -Name Ethernet0 | fl -Property *
Get-NetAdapterHardwareInfo -Name Ethernet0 | 
    fl -Property CimClass, CimInstanceProperties,
                 PcieLinkSpeed, PcieMaxLinkSpeed, DeviceType, Version
                 


