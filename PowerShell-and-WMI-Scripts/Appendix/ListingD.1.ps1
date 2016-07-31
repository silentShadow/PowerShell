function invoke-website {
param (
[parameter(ParameterSetName="RS")]
[switch]$rs,
[parameter(ParameterSetName="RSWMI")]
[switch]$rswmi,
[parameter(ParameterSetName="Book")]
[switch]$book,
[parameter(ParameterSetName="Forum")]
[switch]$forum,
[parameter(ParameterSetName="Guy")]
[switch]$guy,
[parameter(ParameterSetName="Team")]
[switch]$team,
[parameter(ParameterSetName="WMI")]
[switch]$wmi

)



switch ($psCmdlet.ParameterSetName) {
 "RS"     {$url = "http://msmvps.com/blogs/RichardSiddaway/Default.aspx" }
 "RSWMI"  {$url = "http://itknowledgeexchange.techtarget.com/powershell/" }
 "Book"   {$url = "http://www.manning.com/siddaway2" }
 "Forum"  {$url =  "http://www.manning-sandbox.com/forum.jspa?forumID=719&start=0"}
 "Guy"    {$url =  "http://blogs.technet.com/b/heyscriptingguy/"}
 "Team"   {$url =  "http://blogs.msdn.com/b/powershell/"} 
 "WMI"   {$url =  "http://blogs.msdn.com/b/wmi/"}
 default {Write-Host "Error!!! Unknown URL" }
}

Start-Process $url


}