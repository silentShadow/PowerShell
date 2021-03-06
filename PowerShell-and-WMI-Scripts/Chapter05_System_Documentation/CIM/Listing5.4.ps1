##
## Assumes that remote machine is running PowerShell v3
##
# Requires -Version 3
$arch = DATA {
ConvertFrom-StringData -StringData @'
0 = x86
9 = x64
'@
}

$fam = DATA {
ConvertFrom-StringData -StringData @'
1 = Other
2 = Unknown
3 = 8086
4 = 80286
5 = Intel386™ Processor
6 = Intel486™ Processor
7 = 8087
8 = 80287
9 = 80387
10 = 80487
15 = Celeron™
24 = AMD Duron™ Processor Family
29 = AMD Athlon™ Processor Family
30 = AMD2900 Family
112 = Hobbit Family
131 = AMD Athlon™ 64 Processor Family
132 = AMD Opteron™ Processor Family
190 = K7
'@
}

$type = DATA {
ConvertFrom-StringData -StringData @'
1 = Other
2 = Unknown
3 = Central Processor
4 = Math Processor
5 = DSP Processor
6 = Video Processor
'@
}
function get-cputype {
[CmdletBinding()]
param (
 [parameter(ValueFromPipeline=$true,
   ValueFromPipelineByPropertyName=$true)]
 [string]$computername="$env:COMPUTERNAME"
)  
PROCESS {
 Get-CimInstance -ClassName Win32_Processor `
  -ComputerName $computername | 
 select DeviceID, 
 @{Name="Processor Type"; 
 Expression={$type["$($_.ProcessorType)"]}},
 Manufacturer, Name, Description,
 @{Name="CPU Family"; 
 Expression={$fam["$($_.Family)"]}}, 
 @{Name="CPU Architecture"; 
 Expression={$arch["$($_.Architecture)"]}},
 NumberOfCores, NumberOfLogicalProcessors, AddressWidth, 
 DataWidth,  CurrentClockSpeed, MaxClockSpeed, 
 ExtClock,  L2CacheSize, L2CacheSpeed, L3CacheSize, 
 L3CacheSpeed,  CurrentVoltage, PowerManagementSupported,
 ProcessorId, SocketDesignation, Status
}
}