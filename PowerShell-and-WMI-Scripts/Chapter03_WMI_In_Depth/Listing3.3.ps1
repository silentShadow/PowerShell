$namespace = "root\cimv2"

Get-WmiObject -Namespace $namespace -Class __Win32Provider | 
foreach {
  $provider = $_.Name
  "Provider: $provider"
  
  $refs = Get-WmiObject -Namespace $namespace -Query "REFERENCES OF {__Win32Provider.Name='$provider'}"
  
  foreach ($ref in $refs) {
   
    $type = $ref.__CLASS
    " Registration: $type"
    
    switch ($type) {
     
     "__PropertyProviderRegistration" {
            "  does not have classes"
            break
     }
     
     "__ClassProviderRegistration" {
            "  only provides class definitions"
            break
     }
     
     "__EventConsumerProviderRegistration" {
            "  uses these classes"
            "    $($ref.ConsumerClassNames)"
            break
     }
          
     "__EventProviderRegistration" {
           "  queries these classes:"
           foreach ($query in $ref.EventQueryList) {
             $a = $query -split " "
             "    $($a[($a.length-1)])"  
           }
           break      
     }
     
     default {
              "  supplies these classes:"
              Get-WmiObject -Namespace $namespace -List -Amended |
              foreach {
                if ($_.Qualifiers["provider"].Value -eq "$provider"){ 
                  "    $($_.Name)" 
                }
              } # class list
              break
       }
   } #switch
  } # refs 
} # provider loop
