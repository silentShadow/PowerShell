##
## Assumes that remote machine is running PowerShell v3
##
# Requires -Version3
Import-Csv computers.csv | 
foreach {
  $system = "" | 
  select Name, Make, Model, CPUs, Cores, LogProc, Speed, Memory, Windows, SP

  $server = Get-CimInstance -ClassName Win32_ComputerSystem `
  -ComputerName $_.Computer
  
  $system.Name = $server.Name
  $system.Make = $server.Manufacturer
  $system.Model = $server.Model
  $system.Memory = $server.TotalPhysicalMemory
  $system.CPUs = $server.NumberOfProcessors

  $cpu = Get-CimInstance -ClassName Win32_Processor `
  -ComputerName $_.Computer | select -First 1
  
  $system.Speed = $cpu.MaxClockSpeed
  
  $os = Get-CimInstance -ClassName Win32_OperatingSystem `
  -ComputerName $_.Computer
  
  $system.Windows =  $os.Caption
  $system.SP =  $os.ServicePackMajorVersion

  if (($os.Version -split "\.")[0] -ge 6) {
    $system.Cores = $cpu.NumberOfCores
    $system.LogProc = $cpu.NumberOfLogicalProcessors
  }
  else {
    $system.CPUs = ""
    $system.Cores = $server.NumberOfProcessors
  }

  $system
}  | 
Format-Table -AutoSize -Wrap