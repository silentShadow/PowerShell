function get-key {
[CmdletBinding()]
param (
    [string]
    [ValidateNotNullOrEmpty()]
    $class
)
  $t = [WMIClass]$class
  $t.properties |
  select @{Name="PName";Expression={$_.name}} -ExpandProperty Qualifiers |
  where {$_.Name -eq "key"} |
  foreach {"The key for the $class class is $($_.Pname)"}
}