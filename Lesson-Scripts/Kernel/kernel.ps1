Get-WinEvent -ProviderName Microsoft-Windows-Kernel-General | gm


# Get all General Kernel events for today
Get-WinEvent -FilterHashtable @{ 
    providerName='Microsoft-Windows-Kernel-General'
    starttime=$today
} 


# Show only the message property details
Get-WinEvent -FilterHashtable @{ 
    providerName='Microsoft-Windows-Kernel-General'
    starttime=$today
} | select -ExpandProperty message


# Filter only the id and message properties
# Format in a list
Get-WinEvent -FilterHashtable @{ 
    providerName='Microsoft-Windows-Kernel-General'
    starttime=$today
} | fl -Property id, message


# Put everything in a grid, in a new window
Get-WinEvent -FilterHashtable @{ 
    providerName='Microsoft-Windows-Kernel-General'
    starttime=$today
} | Out-GridView