# in progress "C:\hsgTest\projects\Get-EVVersion\Get-EVVersion08_01.ps1" with input parameter an Agent log in txt format (save as txt from logviewer) and paste results to clipboard

param ( 
[Parameter(mandatory=$true)][string] $InputFile
)

# param works as a script but does not come up when an executable. 
# That was because I had to select "Show PowerShell Console" when crearing the executable with PowerGUI


# "C:\hsgTest\projects\Get-EVVersion\Get-EVVersion08_01.ps1" based on working
# "C:\hsgTest\projects\Get-EVVersion\Get-EVVersion04_01.ps1" (- some Comments) with results:



# set Clipboard

. C:\posh\projects\Clipboard\Set-Clipboard.ps1


# $log1 for Get-Content of it$log1 = Get-Content C:\hsgTest\input\BACKUP_filtered.XLOG

$AgentLog = New-Object PSObject
$AgentLog | Add-Member NoteProperty LogPath "C:\-"
$AgentLog | Add-Member NoteProperty AgentVersion "-.-"
$AgentLog | Add-Member NoteProperty VaultVersion "-.-"
$AgentLog | Add-Member NoteProperty HostName "-"
$AgentLog | Add-Member NoteProperty IPAddress "-.-.-.-"
$AgentLog | Add-Member NoteProperty TaskName "-"


$log1 = Get-Content $InputFile

$AgentLog.LogPath = $log1[0].PSPath

$a = $log1 | Where-Object {$_.Contains(" Agent Version ") -eq $true} | ForEach-Object {$_.Split(' ')} 
$b = $a | Select-string -Pattern "Version" -Context 0,1 | Select-Object -Unique
$AgentLog.AgentVersion = ($b.Context.PostContext)[0]
# one difference is there is no need to split the Vault Version line
$a = $log1 | Where-Object {$_.Contains(" Vault Version ") -eq $true} | Sort-Object -Unique | ForEach-Object {$_.Split(' Vault Version ')} 
$AgentLog.VaultVersion = $a[-1]


#PS C:\windows\system32> $a = $log1 | Where-Object {$_.Contains(" Vault Version ") -eq $true} | Sort-Object -Unique | ForEach-Object {$_.Split(' Vault Version ')} 
#
#PS C:\windows\system32> $AgentLog.VaultVersion = $a[-1]
#PS C:\windows\system32> $AgentLog
#
#
#HostName     : Host-1
#IPAddress    : 192.168.1.1
#TaskName     : Host-1-EXCH
#VaultVersion : 7.01
#LogPath      : C:\hsgTest\input\BACKUP_filtered.XLOG

$a = $log1 | Where-Object {$_.Contains("hn=") -eq $true} | ForEach-Object {$_.Split(', ')} | Where-Object {$_.Contains("hn=") -eq $true} | Sort-Object -Unique | ForEach-Object {$_.Split('hn=')} 

$AgentLog.HostName = $a[-1]

$a = $log1 | Where-Object {$_.Contains("hn=") -eq $true} | ForEach-Object {$_.Split(', ')} | Where-Object {$_.Contains("ip=") -eq $true} | Sort-Object -Unique | ForEach-Object {$_.Split('ip=')} 

$AgentLog.IPAddress = $a[-1]

$a = $log1 | Where-Object {$_.Contains("tn=") -eq $true} | ForEach-Object {$_.Split(', ')} | Where-Object {$_.Contains("tn=") -eq $true} | Sort-Object -Unique | ForEach-Object {$_.Split('tn=')} 
$AgentLog.TaskName = $a[-1]


# Use case
# $AgentLog | ft *
$AgentLog | Set-Clipboard
 
#Once pasted frm clipboard the result is:
#
#
#LogPath      : C:\hsgTest\input\BACKUP_filtered.XLOG
#AgentVersion : 7.24.3120
#VaultVersion : 7.01
#HostName     : Host-1
#IPAddress    : 192.168.1.1
#TaskName     : Host-1-EXCH
#
#
