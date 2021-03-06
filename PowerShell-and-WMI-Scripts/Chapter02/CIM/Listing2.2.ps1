##
## Assumes that remote machine is running PowerShell v3
##
# Requires -Version 3
param (
    [string]$computername = "localhost"
)
    Get-CimInstance -ClassName Win32_DiskDrive -ComputerName $computername | 
    Format-List DeviceID, 
    Status, 
    Index, 
    InterfaceType, 
    Partitions, 
    BytesPerSector, 
    SectorsPerTrack, 
    TracksPerCylinder,
    TotalHeads, 
    TotalCylinders, 
    TotalTracks, 
    TotalSectors,
    @{Name="Disk Size (GB)"; Expression={"{0:F3}" -f $($_.Size/1GB)}}