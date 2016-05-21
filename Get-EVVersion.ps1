#working "C:\hsgTest\projects\Get-EVVersion\Get-EVVersion09_05.ps1" for loop to increment through array

param ( 
[Parameter(mandatory=$false)][string] $InputFile = 'C:\posh\input\Backup.LOG' # since I use the same file for testing , I should check against an expected output result
)

# param works as a script but does not come up when an executable. 
# That was because I had to select "Show PowerShell Console" when crearing the executable with PowerGUI


# "C:\hsgTest\projects\Get-EVVersion\Get-EVVersion09_05.ps1" based on working
# "C:\hsgTest\projects\Get-EVVersion\Get-EVVersion09_04.ps1" array detection and property param in array



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
$VaultLog | Add-Member NoteProperty TaskID "-"
$VaultLog | Add-Member NoteProperty SafesetNumber "-"
$VaultLog | Add-Member NoteProperty VUID "-"


$log1 = Get-Content $InputFile
$VaultLog.LogPath = $log1[1].PSPath 
$VaultLog.LogName = $log1[1].PSChildName



$A0 = @{key0 = "Vault: ";key1 = " ";key2 = "";key3 = "Vault:";key4 = "VaultName"}
$A1 = @{key0 = "EVault Software Director Version ";key1 = " ";key2 = "";key3 = "Version";key4 = "VaultVersion"}
$A2 = @{key0 = "vid=";key1 = " ";key2 = "";key3 = "vid=";key4 = "VUID"}
$A3 = @{key0 = "hn = ";key1 = " ";key2 = "";key3 = "=";key4 = "AgentHostname"}
$A4 = @{key0 = "ip = ";key1 = " ";key2 = "";key3 = "=";key4 = "AgentIP"}
$A5 = @{key0 = "Agent version is <";key1 = "<";key2 = ">";key3 = "is ";key4 = "AgentVersion"}
$A6 = @{key0 = "tn = ";key1 = " ";key2 = "";key3 = "=";key4 = "TaskName"}
$A7 = @{key0 = "tid= ";key1 = " ";key2 = "";key3 = "tid=";key4 = "TaskID"}
$A8 = @{key0 = "catalog number is ";key1 = " ";key2 = "";key3 = "is";key4 = "SafesetNumber"}



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

for($counter = 0; $counter -lt $Keys.Length; $counter++){
	$a = $log1 | Where-Object {$_ -match $Keys[$counter].key0 } | ForEach-Object {$_.Split($Keys[$counter].key1)} | ForEach-Object {$_.Split($Keys[$counter].key2)}

	$i = 0
	foreach ($element in $a){
		$i++
		if ($element.Contains($Keys[$counter].key3)){
			$temp = $Keys[$counter].key4 # is a workaround as "$VaultLog."$Keys.key4" = $a[$i]" does not bring the same result
			$VaultLog."$temp" = $a[$i]
		}
	}
}

# Use case
$VaultLog | Set-Clipboard
 
#Once pasted from clipboard the result is:
#LogPath       : C:\posh\input\Backup.LOG
#LogName       : Backup.LOG
#VaultName     : VAULT1
#VaultVersion  : 7.01.6124
#AgentHostname : NETAPP1
#AgentIP       : 172.16.179.81
#AgentVersion  : 7.21.2205
#TaskName      : Filer1
#TaskID        : 95c085fc-2f80-4163-aa10-72e46c6bf10a
#SafesetNumber : 81
#VUID          : 0296bd61-eaff-48c1-a66e-364b12a6771a