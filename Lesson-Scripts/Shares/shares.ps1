<#
Get-CimClass -ClassName *share*


Get-CimInstance -ClassName Win32_Share
Get-CimInstance -ClassName Win32_Share | gm
Get-CimInstance -ClassName Win32_Share | fl *
#>


<#
    Creating the Trustee for the share
#>

$trustee = Get-WmiObject -Class Win32_Trustee -ComputerName $env:COMPUTERNAME -List

#$trustee.Domain = $env:USERDOMAIN
$trustee.Name = $env:USERNAME



<#
    Creating the ACLs for the share
#>

$ace = Get-WmiObject -Class Win32_ACE -List
$ace

$full = 2032127
$change = 1245631
$read = 1179785

$ace.AccessMask = $full
$ace.AceFlags = 3
$ace.AceType = 0
$ace.Trustee = $trustee



<#
    Creating the Security Descriptor for the network share
#>

$sd = Get-WmiObject -Class Win32_SecurityDescriptor -List

# If this flag is not set or if it is and the DACL is $null, then everyone has full access
# 4 means the SD has a DACL
$sd.ControlFlags = 4
$sd.DACL = $ace
$sd.Group = $trustee
$sd.Owner = $trustee


<#
    Set the param vals for the share
#>

$path = "C:\Users\SecretShare"
$name = "SecretShare$"
$type = 0
$max  = 20
$description = "this is a secret share"
$pass = "P@ssW0rd1"


$share = Get-WmiObject -Class Win32_Share -ComputerName $env:COMPUTERNAME -List
$share | gm
$share.Create($path, $name, $type, $max, $description, $pass, $sd)
$share.Delete()

