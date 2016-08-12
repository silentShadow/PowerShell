Set objShell = CreateObject("Wscript.shell")
objShell.run("powershell -WindowStyle Hidden -executionpolicy bypass -file c:\fso\CleanupFiles.ps1") 
REM objShell.run("powershell -noexit -command ""&{ ""called cleanup script"" >>c:\fso\mylogging.txt}""")