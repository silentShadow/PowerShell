$memuse = DATA {
ConvertFrom-StringData -StringData @'
0 = Reserved 
1 = Other 
2 = Unknown 
3 = System memory 
4 = Video memory 
5 = Flash memory 
6 = Nonvolatile RAM
7 = Cache memory
'@
}

$memcheck = DATA {
ConvertFrom-StringData -StringData @'
0 = Reserved 
1 = Other 
2 = Unknown 
3 = None 
4 = Parity 
5 = Single-bit ECC
6 = Multi-bit ECC 
7 = CRC
'@
}

$memform = DATA {
ConvertFrom-StringData -StringData @'
0 = Unknown
1 = Other 
2 = SIP 
3 = DIP 
4 = ZIP 
5 = SOJ 
6 = Proprietary 
7 = SIMM
8 = DIMM
9 = TSOP 
10 = PGA
11 = RIMM 
12 = SODIMM 
13 = SRIMM 
14 = SMD 
15 = SSMP 
16 = QFP 
17 = TQFP 
18 = SOIC 
19 = LCC 
20 = PLCC 
21 = BGA 
22 = FPBGA 
23 = LGA
'@
}

$memtype = DATA {
ConvertFrom-StringData -StringData @'
0 = Unknown 
1 = Other 
2 = DRAM 
3 = Synchronous DRAM 
4 = Cache DRAM 
5 = EDO 
6 = EDRAM 
7 = VRAM 
8 = SRAM 
9 = RAM 
10 = ROM 
11 = Flash 
12 = EEPROM 
13 = FEPROM 
14 = EPROM 
15 = CDRAM 
16 = 3DRAM 
17 = SDRAM 
18 = SGRAM 
19 = RDRAM 
20 = DDR 
21 = DDR-2
'@
}

$memdetail = DATA {
ConvertFrom-StringData -StringData @'
1 = Reserved 
2 = Other 
4 = Unknown 
8 = Fast-paged 
16 = Static column 
32 = Pseudo-static 
64 = RAMBUS 
128 = Synchronous 
256 = CMOS 
512 = EDO 
1024 = Window DRAM 
2048 = Cache DRAM 
4096 = Nonvolatile
'@
}

function get-memory {
[CmdletBinding()]
param (
 [parameter(ValueFromPipeline=$true,
   ValueFromPipelineByPropertyName=$true)]
 [string]$computername="$env:COMPUTERNAME"
)  

PROCESS {
Write-verbose "Memmory Array" 
 Get-WmiObject -Class Win32_PhysicalMemoryArray `
 -ComputerName $computername | 
 Select @{Name="Location"; Expression={
  if ($_.Location -eq 3){"System Board"}
  else {"Other"}
 } },
 @{Name="Use"; 
 Expression={$memuse["$($_.Use)"]}},
 MemoryDevices, HotSwappable,
 @{Name="MaxRAM(GB)"; 
 Expression={[math]::round($($_.MaxCapacity/1mB), 2)}},
 @{Name="CheckType"; 
 Expression={$memcheck["$($_.MemoryErrorCorrection)"]}}

Write-Verbose "`n Physical memory chip"
 Get-WmiObject Win32_PhysicalMemory -ComputerName $computername | 
 select BankLabel,
 @{Name="Size(GB)"; 
 Expression={[math]::round($($_.Capacity/1gB), 2)}},
 DataWidth, DeviceLocator,
 @{Name="Form"; 
 Expression={$memform["$($_.FormFactor)"]}},
 @{Name="Type"; 
 Expression={$memtype["$($_.MemoryType)"]}},
 Speed, TotalWidth,
 @{Name="Detail"; 
 Expression={$memdetail["$($_.TypeDetail)"]}}
} 
}