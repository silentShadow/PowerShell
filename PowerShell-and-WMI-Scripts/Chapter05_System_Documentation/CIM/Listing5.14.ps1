##
## Assumes that remote machine is running PowerShell v3
##
# Requires -Version 3
$sku = DATA {ConvertFrom-StringData -StringData @'
0 = Undefined 
1 = Ultimate Edition 
2 = Home Basic Edition 
3 = Home Basic Premium Edition 
4 = Enterprise Edition 
5 = Home Basic N Edition 
6 = Business Edition 
7 = Standard Server Edition 
8 = Datacenter Server Edition 
9 = Small Business Server Edition 
10 = Enterprise Server Edition 
11 = Starter Edition 
12 = Datacenter Server Core Edition 
13 = Standard Server Core Edition 
14 = Enterprise Server Core Edition 
15= Enterprise Server Edition for Itanium-Based Systems 
16 = Business N Edition 
17 = Web Server Edition 
18 = Cluster Server Edition 
19 = Home Server Edition 
20 = Storage Express Server Edition 
21 = Storage Standard Server Edition 
22 = Storage Workgroup Server Edition 
23 = Storage Enterprise Server Edition 
24 = Server For Small Business Edition 
25 = Small Business Server Premium Edition
'@}

$os = DATA {
ConvertFrom-StringData -StringData @'
14 = MSDOS
15 = WIN3X
16 = WIN95
17 = WIN98
18 = WINNT
19 = WINCE
'@
}

##
## for language and locale settings see
## http://msdn.microsoft.com/en-us/goglobal/bb964664.aspx
##

$lang = DATA {
ConvertFrom-StringData -StringData @'
1033 = English US
2057 = English UK
'@
}


$loc = DATA {
ConvertFrom-StringData -StringData @'
0409 = English US
0809 = English UK
'@
}

## codeset info
## http://msdn.microsoft.com/en-us/goglobal/bb964654.aspx
$code = DATA {
ConvertFrom-StringData -StringData @'
1252 = Latin I
'@
}

## country codes
##http://msdn.microsoft.com/en-us/library/dd387951(VS.85).aspx
$country = DATA {
ConvertFrom-StringData -StringData @'
1 = USA
44 = United Kingdom
'@
}

$fboost = DATA {
ConvertFrom-StringData -StringData @'
0 = None
1 = Minimum 
2 = (Default) Maximum
'@
}

$depsupport = DATA {
ConvertFrom-StringData -StringData @'
0 = Always Off
1 = Always On
2 = Opt In
3 = Opt Out
'@
}

function get-operatingsystem {
[CmdletBinding()]
param (
 [parameter(ValueFromPipeline=$true,
   ValueFromPipelineByPropertyName=$true)]
 [string]$computername="$env:COMPUTERNAME"
) 
PROCESS { 
 Get-CimInstance -ClassName Win32_OperatingSystem -ComputerName $computername | 
 select CSName, Caption, 
 @{Name="Operating System SKU"; 
 Expression={$sku["$($_.OperatingSystemSKU)"]}},
 SerialNumber, ServicePackMajorVersion, 
 ServicePackMinorVersion, BuildNumber, Version, OSArchitecture,
 SystemDevice, SystemDrive, WindowsDirectory, SystemDirectory, 
 @{Name="OS Language"; Expression={$lang["$($_.OSLanguage)"]}}, 
 @{Name="OS Type"; Expression={$os["$($_.OSType)"]}}, 
 @{Name="Code Set"; Expression={$code["$($_.CodeSet)"]}}, 
 @{Name="Country Code"; Expression={$country["$($_.CountryCode)"]}}, 
 EncryptionLevel,
 @{Name="Foreground Application Boost"; 
 Expression={$fboost["$($_.ForegroundApplicationBoost)"]}},
 DataExecutionPrevention_32BitApplications,
 DataExecutionPrevention_Available, DataExecutionPrevention_Drivers,
 @{Name="Data Execution Prevention Support Policy"; 
 Expression={$depsupport["$($_.DataExecutionPrevention_SupportPolicy)"]}},  
 InstallDate, LastBootUpTime, LocalDateTime, 
 @{Name=”Offset from GMT”; Expression={"$($_.CurrentTimeZone) minutes"}},
 @{Name="Locale "; Expression={$loc["$($_.Locale)"]}},
 MaxNumberOfProcesses, 
 @{Name="Max Process Memory Size (GB)"; 
 Expression={"{0:F3}" -f $($_.MaxProcessMemorySize*1kb /1GB)}},
 PAEEnabled, 
 @{Name="Free Physical Memory (GB)"; 
 Expression={"{0:F3}" -f $($_.FreePhysicalMemory/1GB*1kb)}},
 @{Name="Size Stored In Paging Files (GB)"; 
 Expression={"{0:F3}" -f $($_.SizeStoredInPagingFiles *1kb /1GB)}},
 @{Name="Free Space In Paging Files (GB)"; 
 Expression={"{0:F3}" -f $($_.FreeSpaceInPagingFiles *1kb /1GB)}},
 @{Name="Total Visible Memory Size (GB)"; 
 Expression={"{0:F3}" -f $($_.TotalVisibleMemorySize *1kb /1GB)}}, 
 @{Name="Total Virtual Memory Size (GB)"; 
 Expression={"{0:F3}" -f $($_.TotalVirtualMemorySize *1kb /1GB)}}, 
 @{Name="Free Virtual Memory (GB)"; 
 Expression={"{0:F3}" -f $($_.FreeVirtualMemory*1kb /1GB)}}
}
}