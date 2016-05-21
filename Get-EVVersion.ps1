#working but still in progress for 9_04 "C:\hsgTest\projects\Get-EVVersion\Get-EVVersion09_03.ps1" make a foreeach to apply each arrays to the same function 

param ( 
[Parameter(mandatory=$false)][string] $InputFile = 'C:\posh\input\Backup.LOG' # since I use the same file for testing , I should check against an expected output result
)

# param works as a script but does not come up when an executable. 
# That was because I had to select "Show PowerShell Console" when crearing the executable with PowerGUI


# "C:\hsgTest\projects\Get-EVVersion\Get-EVVersion09_03.ps1" based on working
# "C:\hsgTest\projects\Get-EVVersion\GGet-EVVersion09_02.ps1" array detection and property param in array



# set Clipboard

. C:\posh\projects\Clipboard\Set-Clipboard_fc.ps1


# $log1 for Get-Content of it $log1 = Get-Content C:\hsgTest\input\Backup-526ABFBB-48AC-29B4.LOG

$VaultLog = New-Object PSObject
$VaultLog | Add-Member NoteProperty LogPath "-"
$VaultLog | Add-Member NoteProperty LogName "-"
$VaultLog | Add-Member NoteProperty VaultName "-"
$VaultLog | Add-Member NoteProperty VaultVersion "-"
$VaultLog | Add-Member NoteProperty AgentHostname "-"
$VaultLog | Add-Member NoteProperty AgentIP "-.-.-.-"
$VaultLog | Add-Member NoteProperty AgentVersion "-"
$VaultLog | Add-Member NoteProperty TaskName "-"
$VaultLog | Add-Member NoteProperty TaskID "(-)"
$VaultLog | Add-Member NoteProperty SafesetNumber "-"
$VaultLog | Add-Member NoteProperty VUID "-"


$log1 = Get-Content $InputFile
$VaultLog.LogPath = $log1[1].PSPath 
$VaultLog.LogName = $log1[1].PSChildName

#VaultName
#$a = $log1 | Where-Object {$_ -match ("Vault: ") } | ForEach-Object {$_.Split(" ")}
#$VaultLog.VaultName = $a[-1]

#$VaultNameArray = @{key0 = "Vault: ";key1 = " ";key2 = "";key3 = "Vault:";key4 = "VaultName"}
#$VaultVersionArray = @{key0 = "EVault Software Director Version ";key1 = " ";key2 = "";key3 = "Version";key4 = "VaultVersion"}
#$VUIDArray = @{key0 = "vid=";key1 = " ";key2 = "";key3 = "vid=";key4 = "VUID"}
#$AgentHostnameArray = @{key0 = "hn = ";key1 = " ";key2 = "";key3 = "=";key4 = "AgentHostname"}
#$AgentIPArray = @{key0 = "ip = ";key1 = " ";key2 = "";key3 = "=";key4 = "AgentIP"}
#$AgentVersionArray = @{key0 = "Agent version is ";key1 = " ";key2 = "";key3 = "is";key4 = "AgentVersion"}
#$TaskNameArray = @{key0 = "tn = ";key1 = " ";key2 = "";key3 = "=";key4 = "TaskName"}
#$TaskIDArray = @{key0 = "tid= ";key1 = " ";key2 = "";key3 = "tid=";key4 = "TaskID"}
#$SafesetNumberArray = @{key0 = "catalog number is ";key1 = " ";key2 = "";key3 = "is";key4 = "SafesetNumber"}


$A0 = @{key0 = "Vault: ";key1 = " ";key2 = "";key3 = "Vault:";key4 = "VaultName"}
$A1 = @{key0 = "EVault Software Director Version ";key1 = " ";key2 = "";key3 = "Version";key4 = "VaultVersion"}
$A2 = @{key0 = "vid=";key1 = " ";key2 = "";key3 = "vid=";key4 = "VUID"}
$A3 = @{key0 = "hn = ";key1 = " ";key2 = "";key3 = "=";key4 = "AgentHostname"}
$A4 = @{key0 = "ip = ";key1 = " ";key2 = "";key3 = "=";key4 = "AgentIP"}
$A5 = @{key0 = "Agent version is ";key1 = " ";key2 = "";key3 = "is";key4 = "AgentVersion"}
$A6 = @{key0 = "tn = ";key1 = " ";key2 = "";key3 = "=";key4 = "TaskName"}
$A7 = @{key0 = "tid= ";key1 = " ";key2 = "";key3 = "tid=";key4 = "TaskID"}
$A8 = @{key0 = "catalog number is ";key1 = " ";key2 = "";key3 = "is";key4 = "SafesetNumber"}


##SafesetNumber
#$a = $log1 | Where-Object {$_ -match ("catalog number is ") } | ForEach-Object {$_.Split(" ")}
#$VaultLog.SafesetNumber = $a[-1]

##TaskID
#$a = $log1 | Where-Object {$_ -match ("tid= ") } | ForEach-Object {$_.Split(" ")}
#$VaultLog.TaskID = $a[-1]

##TaskName
#$a = $log1 | Where-Object {$_ -match ("tn = ") } | ForEach-Object {$_.Split(" ")}
#$VaultLog.TaskName = $a[-1]

##AgentVersion
#$a = $log1 | Where-Object {$_ -match ("Agent version is ") } | ForEach-Object {$_.Split(" ")}
#$VaultLog.AgentVersion = $a[-1]

##AgentIP
#$a = $log1 | Where-Object {$_ -match ("ip = ") } | ForEach-Object {$_.Split(" ")}
#$VaultLog.AgentIP = $a[-1]

##AgentHostname
#$a = $log1 | Where-Object {$_ -match ("hn = ") } | ForEach-Object {$_.Split(" ")}
#$VaultLog.AgentHostname = $a[-1]

##VUID
#$a = $log1 | Where-Object {$_ -match ("vid=") } | ForEach-Object {$_.Split(" ")}
#$VaultLog.VUID = $a[-1]


$Keys = @(
$A0,
$A1,
$A2,
$A3,
$A4,
$A5,
$A6,
$A7,
$A8
)

$a = $log1 | Where-Object {$_ -match $Keys[0].key0 } | ForEach-Object {$_.Split($Keys[0].key1)} | ForEach-Object {$_.Split($Keys[0].key2)}

$i = 0
foreach ($element in $a){
	$i++
	if ($element.Contains($Keys[0].key3)){
		$temp = $Keys[0].key4 # is a workaround as "$VaultLog."$Keys.key4" = $a[$i]" does not bring the same result
		$VaultLog."$temp" = $a[$i]
	}
}

##VaultVersion
#
#$Keys = @{key0 = "EVault Software Director Version ";key1 = " ";key2 = "";key3 = "Version";key4 = "VaultVersion"}
#
#$a = $log1 | Where-Object {$_ -match $Keys.key0 } | ForEach-Object {$_.Split($Keys.key1)} | ForEach-Object {$_.Split($Keys.key2)}
#
#$i = 0
#foreach ($element in $a){
#	$i++
#	if ($element.Contains($Keys.key3)){
#		$temp = $Keys.key4 # is a workaround as "$VaultLog."$Keys.key4" = $a[$i]" does not bring the same result
#		$VaultLog."$temp" = $a[$i]
#	}
#}

##VaultVersion
#$a = $log1 | Where-Object {$_ -match ("EVault Software Director Version ") } | ForEach-Object {$_.Split(" ")}
#
##function to take the next value after "Version"
#$i = 0
#foreach ($element in $a){
#	$i++
#	if ($element.Contains("Version")){
#		$VaultLog.VaultVersion = $a[$i]
#	}
#}





#$log1[1].PSChildName
#$a = $log1 | Where-Object {$_ -match ("tid= ") }
#$b = $a | ForEach-Object {$_.Split(" ")}
#$VaultLog.TaskID =$b[-1]  
#(362)


# Use case
$VaultLog | Set-Clipboard
 
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
