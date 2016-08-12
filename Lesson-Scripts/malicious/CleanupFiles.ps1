Param(
       [string]$path = "c:\test",
       [switch]$rename = $true
       )
 "called cleanup script $((get-date).tostring())" >>c:\fso\mylogging.txt
 Get-ChildItem -Path $path -Recurse | 
 foreach-object -Begin {$count = 0} -process { 
   if($_.name.length -ne $_.name.trim().length) 
    { 
     if($rename)
      { 
        Rename-Item -Path $_.fullname -NewName ("{0}{1}{2}" -f `
         $_.basename.trim(),$count,$_.extension) 
        $count++
        }
     else
      {"$($_.basename) contains a leading space"}} }
