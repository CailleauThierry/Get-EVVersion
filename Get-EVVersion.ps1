# working "C:\hsgTest\projects\Get-EVVersion\Get-EVVersion08_01.ps1" "dot sourcing" the Set-Clipboard_fc.ps1, and streamlining next parameter selection

param ( 
[Parameter(mandatory=$true)][string] $InputFile
)

# param works as a script but does not come up when an executable. 
# That was because I had to select "Show PowerShell Console" when crearing the executable with PowerGUI


# "C:\hsgTest\projects\Get-EVVersion\Get-EVVersion08_01.ps1" based on working
# "C:\hsgTest\projects\Get-EVVersion\Get-EVVersion04_01.ps1" (- some Comments) with results:

# set Clipboard

. C:\posh\projects\Clipboard\Set-Clipboard_fc.ps1

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

#Agent Version
$a = $log1 | Where-Object {$_ -match (" Agent Version") } | ForEach-Object {$_.Split(" ")}

$i = 0
foreach ($element in $a){
	$i++
	if ($element.Contains("Version")){
		$AgentLog.AgentVersion = $a[$i]
	}
}


#Vault Version
$a = $log1 | Where-Object {$_ -match (" Vault Version") } | ForEach-Object {$_.Split(" ")}

$i = 0
foreach ($element in $a){
	$i++
	if ($element.Contains("Version")){
		$AgentLog.VaultVersion = $a[$i]
	}
}


#AgentHostname
$a = $log1 | Where-Object {$_ -match (", hn=") } | ForEach-Object {$_.Split("=")} | ForEach-Object {$_.Split(", ")}

$i = 0
foreach ($element in $a){
	$i++
	if ($element.Contains("hn")){
		$AgentLog.HostName = $a[$i]
	}
}

#Agent IPAddress
$a = $log1 | Where-Object {$_ -match (", ip=") } | ForEach-Object {$_.Split("=")} | ForEach-Object {$_.Split(", ")}

$i = 0
foreach ($element in $a){
	$i++
	if ($element.Contains("ip")){
		$AgentLog.IPAddress = $a[$i]
	}
}

#Agent TaskName
$a = $log1 | Where-Object {$_ -match (" tn=") } | ForEach-Object {$_.Split("=")} | ForEach-Object {$_.Split(", ")}

$i = 0
foreach ($element in $a){
	$i++
	if ($element.Contains("tn")){
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
