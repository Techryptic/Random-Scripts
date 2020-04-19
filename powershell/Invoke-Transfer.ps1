Function Invoke-Transfer {
<#
.SYNOPSIS
Invoke-Transfer will allow you to transfer files using a powershell session.

.DESCRIPTION
This powershell script will take a input file, base64 it and create
another powershell script inwhich you can now use the Invoke-Command's 
FilePath paramter to load the script directly ontop another powershell session.


.PARAMETER File
Name of File that is to be transfer.

.EXAMPLE
PS > Invoke-Transfer -File SharpHound.exe
        This will create a file in the same directory called Mod_SharpHound.exe.ps1
PS > Invoke-Command -ComputerName <Server> -FilePath .\Mod_SharpHound.exe.ps1
        This will now create a file in the $home directory of the server machine,
        in this case, Mod_SharpHound.exe is located on <server>.
PS > Invoke-Command -ComputerName <Server> -ScriptBlock{.\Mod_SharpHound.exe.ps1}
        This will run the application on the server.

.LINK
https://techryptic.github.io
#>


[cmdletbinding()]
Param (
[string]$file
)

Process {
"Checking if $file exist..."

if (Test-Path $file -PathType leaf)
{
$fileContent = get-content $file -raw
$fileContentBytes = [System.Text.Encoding]::UTF8.GetBytes($fileContent)
$fileContentEncoded = [System.Convert]::ToBase64String($fileContentBytes)
$finalfile = "Mod_" + $file
$justname = [io.path]::GetFileNameWithoutExtension("$file")

$Title = '$base64data = "'
$Title + 
$fileContentEncoded + 
'"' + "`n" + 
"`$decodedata = [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String(`$base64data))" + 
"`n"+
"Add-Content `$home\Documents\$finalfile `$decodedata"+ "`n`n" | Out-file “$finalfile.ps1”

#base64'ing itself. (Chicken and the egg)
$fileContent2 = get-content “$finalfile.ps1” -raw
$fileContentBytes2 = [System.Text.Encoding]::UTF8.GetBytes($fileContent2)
$fileContentEncoded2 = [System.Convert]::ToBase64String($fileContentBytes2)
$decodedata = [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String($fileContentEncoded2))
##############################
#Writing itself, to itself encoded
$Title = '$base64dataps1 = "'
$Title + 
$fileContentEncoded2 + 
'"' + "`n" + 
"`$decodedata2 = [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String(`$base64dataps1))" + 
"`n"+
"Add-Content `$home\Documents\$finalfile-2.ps1 `$decodedata2" | Out-file “$finalfile.ps1” -Append
##############################
"Finished!"
""
}

else {
""
"DOES NOT EXIST"
}}}
# Uncomment the command below to run script automatically with it's own parameters.
Invoke-Transfer -File SharpHound.exe
