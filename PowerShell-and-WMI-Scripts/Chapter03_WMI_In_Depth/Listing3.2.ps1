function get-namespace {
param ([string]$name)
     Get-WmiObject -Namespace $name -Class "__NAMESPACE" | 
     foreach {
        $ns = "$name\" + $_.Name
        "`nNameSpace: $ns"
        "providers:"
        Get-WmiObject -NameSpace $ns -Class __Win32Provider | 
        select name
        
        get-namespace $("$name\" + $_.Name)
     }
}
"root"
get-namespace "root"
