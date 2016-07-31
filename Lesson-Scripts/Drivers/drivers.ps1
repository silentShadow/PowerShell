Get-WindowsDriver -Online -All
driverquery.exe /v /fo csv | ConvertFrom-Csv | Select-Object 'Display Name','Start Mode','Package Pool(bytes)'

Get-CimClass -ClassName *drive*
$PnPDrives = Get-CimInstance -ClassName Win32_PnPSignedDriver
$sysDrives = Get-CimInstance -ClassName Win32_SystemDriver

$PnPDrives.Count
$sysDrives.Count
$sysDrives.displayname
$sysDrives | Group-Object -Property started
$sysDrives | Group-Object -Property state
$sysDrives | Group-Object -Property status