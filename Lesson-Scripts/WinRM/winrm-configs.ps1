# Is WinRM running on remote computer?
Get-Service -ComputerName 10.1.1.253 -Name winRM


# Set WinRM to run automatically and start service
Set-Service -ComputerName 10.1.1.253 -Name WinRM -StartupType Automatic -Status Running


# Validate it is running and configured for remote comms
Test-WSMan -ComputerName 10.1.1.253 -Verbose


# Netsh rules to add
Invoke-Command -ComputerName 10.1.1.253 -ScriptBlock {
    (Get-Host).Version
    $PSVersionTable
    netsh firewall set service RemoteAdmin 
    netsh advfirewall set currentprofile settings remotemanagement enable
    Set-Item WSMan:\localhost\Client\TrustedHosts -Value *
}