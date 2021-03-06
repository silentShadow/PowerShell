function get-namespace {
param ([string]$name)
     Get-WmiObject -Namespace $name -Class "__NAMESPACE" | 
     foreach {
        "$name\" + $_.Name
        get-namespace $("$name\" + $_.Name)
     }
}
"root"
get-namespace "root"
