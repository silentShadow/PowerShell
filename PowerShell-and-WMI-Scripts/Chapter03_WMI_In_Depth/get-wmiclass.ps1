function get-wmiclass {
 param(
  [string]$namespace='root\cimv2',
  [string]$class='Win32_process'
  )

"Namespace: $namespace Class: $class"
 "Methods"
 Get-WmiObject -Namespace $namespace -Class $class |
 select -First 1 | Get-Member -View all -MemberType method
 
 "`nProperties"
 Get-WmiObject -Namespace $namespace -Class $class |
 select -First 1 | Get-Member -View all -MemberType property

 "`nKey Property"
 $t = [wmiclass]"\\.\$namespace`:$class"
 $t.properties |
 select @{Name="PName";Expression={$_.name}} -ExpandProperty Qualifiers |
 where {$_.Name -eq "key"} |
 foreach {"The key for the $class class is $($_.Pname)"}

 "`nDescription"
 ((Get-WmiObject -List -Namespace $namespace -Class $class -Amended).Qualifiers |
 where {$_.Name -eq "Description"}).Value

}