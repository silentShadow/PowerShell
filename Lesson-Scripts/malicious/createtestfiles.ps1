Param([string]$path = "c:\test",
       [string]$FileBaseName = "myfile.txt",
       [int]$count=4)
  For($i = 0; $i -le $count ;$i ++)
    { $pad = " " * $i
     New-item -Path $path -Name "$pad$FileBasename" -ItemType file}