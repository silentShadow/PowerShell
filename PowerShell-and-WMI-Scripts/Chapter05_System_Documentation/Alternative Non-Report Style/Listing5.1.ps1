$chassis = DATA {
ConvertFrom-StringData -StringData @'
1 = Other 
2 = Unknown 
3 = Desktop 
4 = Low Profile Desktop 
5 = Pizza Box  
6 = Mini Tower 
7 = Tower 
8 = Portable 
9 = Laptop 
10 = Notebook 
11 = Hand Held 
12 = Docking Station 
13 = All in One 
14 = Sub Notebook 
15 =  Space-Saving 
16 = Lunch Box  
17 = Main System Chassis
18 = Expansion Chassis 
19 = SubChassis 
20 = Bus Expansion Chassis 
21 = Peripheral Chassis 
22 = Storage Chassis 
23 = Rack Mount Chassis 
24 = Sealed-Case PC
'@
} 

$obd = DATA {
ConvertFrom-StringData -StringData @'
1 = Other 
2 = Unknown 
3 = Video 
4 = SCSI Controller 
5 = Ethernet 
6 = Token Ring 
7 = Sound
'@
} 

function get-computersystem {
[CmdletBinding()]
param (
 [parameter(ValueFromPipeline=$true,
   ValueFromPipelineByPropertyName=$true)]
 [string]$computername="$env:COMPUTERNAME"
)  
PROCESS {
  Write-Verbose "Computer System"
  Get-WmiObject -Class Win32_ComputerSystem `
  -ComputerName $computername | 
  select Name, Manufacturer, Model, 
  SystemType, Description,
  NumberOfProcessors, NumberOfLogicalProcessors,
  @{Name="RAM(GB)"; 
  Expression={[math]::round($($_.TotalPhysicalMemory/1GB), 2)}}

 Write-Verbose "System Enclosure"
 Get-WmiObject -Class Win32_SystemEnclosure `
 -ComputerName $computername |
 select Manufacturer, Model, 
 @{Name="Chassis"; Expression={$chassis["$($_.ChassisTypes)"]}},
 LockPresent,SerialNumber, SMBIOSAssetTag

 Write-Verbose  "Base Board"
 Get-WmiObject -Class Win32_BaseBoard `
 -ComputerName $computername |
 select Manufacturer, Model, Name,
 SerialNumber, SKU, Product,
 Replaceable, Version
 
 Write-Verbose  "On Board Devices"
  Get-WmiObject -Class Win32_OnBoardDevice `
 -ComputerName $computername |
 select Description,
 @{Name="Device"; 
 Expression={$obd["$($_.DeviceType)"]}}
}
}