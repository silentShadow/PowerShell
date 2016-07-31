set objWMIService = GetObject("winmgmts:" _
      & "{impersonationlevel=impersonate}!\\" _
	  & ".\root\cimv2")

set colProcesses = objWMIService.ExecQuery _
      ("SELECT * FROM Win32_Process")
	  
for each objProcess in colProcesses
    WScript.Echo " "
    WScript.Echo "Process Name : " + objProcess.Name
    WScript.Echo "Handle       : " + objProcess.Handle
    WScript.Echo "Total Handles: " + Cstr(objProcess.HandleCount)
    WScript.Echo "ThreadCount  : " + Cstr(objProcess.ThreadCount)
    WScript.Echo "Path         : " + objProcess.ExecutablePath
next