$mof = @'
#pragma namespace("\\\\.\\Root")

Instance of __NameSpace {
    Name = "EvilNameSpaceHere";
};

#pragma namespace("\\\\.\\Root\\EvilNameSpaceHere")
class My_EvilClass {
    [Key] string EvilName;
    String EvilValue;
    Boolean UseValidation = False;
};

Instance of My_EvilClass {
    EvilName="I hacked you";
    EvilValue="You have been hacked with PowerShell";
    UseValidation=True;
};
'@

$mof | Out-File -Encoding ascii $env:TMP\myMOF.mof

mofcomp.exe $env:TMP\myMOF.mof