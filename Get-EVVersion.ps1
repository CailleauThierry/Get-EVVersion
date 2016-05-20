# working "C:\hsgTest\projects\Get-EVVersion\Get-EVVersion08_03.ps1" "dot sourcing" the Set-Clipboard_fc.ps1, and streamlining next parameter selection. Added "hash tables" for the log's parameter. This will allow later to have the parameters outside of the function (GUI select tool)
# this illustrate hash table for enumeration

param ( 
[Parameter(mandatory=$true)][string] $InputFile
)

# param works as a script but does not come up when an executable. 
# That was because I had to select "Show PowerShell Console" when crearing the executable with PowerGUI


# "C:\hsgTest\projects\Get-EVVersion\Get-EVVersion08_03.ps1" based on working
# "C:\hsgTest\projects\Get-EVVersion\Get-EVVersion08_02.ps1" (- some Comments) with results:

# set Clipboard

. C:\posh\projects\Clipboard\Set-Clipboard_fc.ps1

# $log1 for Get-Content of it$log1 = Get-Content C:\hsgTest\input\BACKUP_filtered.XLOG

$AgentLog = New-Object PSObject
$AgentLog | Add-Member NoteProperty LogPath "C:\-"
$AgentLog | Add-Member NoteProperty LogName "-"
$AgentLog | Add-Member NoteProperty AgentVersion "-.-"
$AgentLog | Add-Member NoteProperty VaultVersion "-.-"
$AgentLog | Add-Member NoteProperty HostName "-"
$AgentLog | Add-Member NoteProperty IPAddress "-.-.-.-"
$AgentLog | Add-Member NoteProperty TaskName "-"

$log1 = Get-Content $InputFile

$AgentLog.LogPath = $log1[1].PSPath
$AgentLog.LogName = $log1[1].PSChildName

#Agent Version
$AgentVersionKeys = @(
" Agent Version",
" ",
" ",
"Version"
)

$a = $log1 | Where-Object {$_ -match ($AgentVersionKeys[0]) } | ForEach-Object {$_.Split($AgentVersionKeys[1])} | ForEach-Object {$_.Split($AgentVersionKeys[2])}

$i = 0
foreach ($element in $a){
	$i++
	if ($element.Contains($AgentVersionKeys[3])){
		$AgentLog.AgentVersion = $a[$i]
	}
}

#Vault Version
$VaultVersionKeys = @(
" Vault Version",
" ",
" ",
"Version"
)

$a = $log1 | Where-Object {$_ -match ($VaultVersionKeys[0]) } | ForEach-Object {$_.Split($VaultVersionKeys[1])} | ForEach-Object {$_.Split($VaultVersionKeys[2])}

$i = 0
foreach ($element in $a){
	$i++
	if ($element.Contains($VaultVersionKeys[3])){
		$AgentLog.VaultVersion = $a[$i]
	}
}


#AgentHostname
$HostNameKeys = @(
", hn=",
"=",
", ",
"hn"
)

$a = $log1 | Where-Object {$_ -match ($HostNameKeys[0]) } | ForEach-Object {$_.Split($HostNameKeys[1])} | ForEach-Object {$_.Split($HostNameKeys[2])}

$i = 0
foreach ($element in $a){
	$i++
	if ($element.Contains($HostNameKeys[3])){
		$AgentLog.HostName = $a[$i]
	}
}

#Agent IPAddress
$IPAddressKeys = @(
", ip=",
"=",
", ",
"ip"
)
$a = $log1 | Where-Object {$_ -match ($IPAddressKeys[0]) } | ForEach-Object {$_.Split($IPAddressKeys[1])} | ForEach-Object {$_.Split($IPAddressKeys[2])}

$i = 0
foreach ($element in $a){
	$i++
	if ($element.Contains($IPAddressKeys[3])){
		$AgentLog.IPAddress = $a[$i]
	}
}

#Agent TaskName
$TaskNameKeys = @(
" tn=",
"=",
", ",
"tn"
)

$a = $log1 | Where-Object {$_ -match ($TaskNameKeys[0]) } | ForEach-Object {$_.Split($TaskNameKeys[1])} | ForEach-Object {$_.Split($TaskNameKeys[2])}

$i = 0
foreach ($element in $a){
	$i++
	if ($element.Contains($TaskNameKeys[3])){
		$AgentLog.TaskName = $a[$i]
	}
}


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
