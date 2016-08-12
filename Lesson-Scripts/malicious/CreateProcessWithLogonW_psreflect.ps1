$Module = New-InMemoryModule -ModuleName ExploitDemo

$LOGON_FLAGS = psenum $Module Demo.LOGON_FLAGS Int32 @{
    LOGON_WITH_PROFILE = 1
    LOGON_NETCREDENTIALS_ONLY = 2
}

$CREATE_FLAGS = psenum $Module Demo.CREATE_FLAGS Int32 @{
    CREATE_DEFAULT_ERROR_MODE =    0x04000000
    CREATE_NEW_CONSOLE =           0x00000010
    CREATE_NEW_PROCESS_GROUP =     0x00000200
    CREATE_SEPARATE_WOW_VDM =      0x00000800
    CREATE_SUSPENDED =             0x00000004
    CREATE_UNICODE_ENVIRONMENT =   0x00000400
    EXTENDED_STARTUPINFO_PRESENT = 0x00080000
} -Bitfield

# You'll want to know ahead of time the proper sizes of the
# STARTUPINFOW structure in both x86 and x64 in order to
# validate that everything lines up properly.
# I use windbg for this:
# dt -v ole32!STARTUPINFOW
# x64 size: 0x68, x86 size: 0x44

$STARTUPINFOW = struct $Module Demo.STARTUPINFOW @{
    cb =              field  0 UInt32
    lpReserved =      field  1 IntPtr # Since this should always be null, an IntPtr is better
    lpDesktop =       field  2 String
    lpTitle =         field  3 String
    dwX =             field  4 UInt32
    dwY =             field  5 UInt32
    dwXSize =         field  6 UInt32
    dwYSize =         field  7 UInt32
    dwXCountChars =   field  8 UInt32
    dwYCountChars =   field  9 UInt32
    dwFillAttribute = field 10 UInt32
    dwFlags =         field 11 UInt32
    wShowWindow =     field 12 UInt16
    cbReserved2 =     field 13 UInt16
    lpReserved2 =     field 14 IntPtr
    hStdInput =       field 15 IntPtr
    hStdOutput =      field 16 IntPtr
    hStdError =       field 17 IntPtr
}

# PSReflect is nice in that it gives you a built-in GetSize method
# so no need to call [System.Runtime.InteropServices.Marshal]::SizeOf()
# $STARTUPINFOW::GetSize()

$PROCESS_INFORMATION = struct $Module Demo.PROCESS_INFORMATION @{
    hProcess =    field 0 IntPtr
    hThread =     field 1 IntPtr
    dwProcessId = field 2 UInt32
    dwThreadId =  field 3 UInt32
}

$FuncDefArgs = @{
    Module = $Module
    Namespace = 'Demo.Advapi32'
    DllName = 'Advapi32'
    FunctionName = 'CreateProcessWithLogonW'
    Charset = 'Unicode'
    ReturnType = [BOOL]
    ParameterTypes = @(
        [String], # lpUsername
        [String], # lpDomain
        [String], # lpPassword
        [UInt32], # dwLogonFlags
        [IntPtr], # lpApplicationName. This should be a [String] but [IntPtr] allows you to pass an actual NULL.
        [Text.StringBuilder], # lpCommandLine. StringBuilder since this can serve as an OUT param too.
        [UInt32], # dwCreationFlags
        [IntPtr], # lpEnvironment
        [IntPtr], # lpCurrentDirectory. This should be a [String] but [IntPtr] allows you to pass an actual NULL.
        $STARTUPINFOW.MakeByRefType(), # lpStartupInfo
        $PROCESS_INFORMATION.MakeByRefType() # lpProcessInfo
    )
}

$Type = Add-Win32Type @FuncDefArgs -SetLastError
# Add-Win32Type returns a hashtable where the keys are the
# defined DLL names so let's pull out kernel32.
$Advapi32 = $Type['Advapi32']

# You need to call CreateInstance in v2 versus New-Object
$StartupInfo = [Activator]::CreateInstance($STARTUPINFOW)
$StartupInfo.cb = $STARTUPINFOW::GetSize()
$ProcInfo = [Activator]::CreateInstance($PROCESS_INFORMATION)

$StrBuilder = New-Object Text.StringBuilder
$null = $StrBuilder.Append('C:\windows\System32\cmd.exe')

$Result = $Advapi32::CreateProcessWithLogonW('UserName',
    [Environment]::MachineName,
    'UserPassword',
    0,
    [IntPtr]::Zero,
    $StrBuilder,
    0,
    [IntPtr]::Zero,
    [IntPtr]::Zero,
    [Ref] $StartupInfo,
    [Ref] $ProcInfo);$LastError = [Runtime.InteropServices.Marshal]::GetLastWin32Error()

if ($Result -eq $False) {
    throw ([ComponentModel.Win32Exception] $LastError)
}
