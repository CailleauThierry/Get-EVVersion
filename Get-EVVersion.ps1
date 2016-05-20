<#
	.SYNOPSIS
		Description still to come

	.DESCRIPTION
		A detailed description of the function.

	.PARAMETER  ParameterA
		The description of the ParameterA parameter.

	.PARAMETER  ParameterB
		The description of the ParameterB parameter.

	.EXAMPLE
		PS C:\> Get-Something -ParameterA 'One value' -ParameterB 32

	.EXAMPLE
		PS C:\> Get-Something 'One value' 32

	.INPUTS
		Evault backup logs in text format

	.OUTPUTS
		TypeName: System.Management.Automation.PSCustomObject

	.NOTES
		Additional information about the function go here.

	.LINK
		about_functions_advanced

	.LINK
		about_comment_based_help

#>


#processing "C:\hsgTest\projects\Get-EVVersion\Get-EVVersion08_06.ps1" for handling error on passing .txt files

param ( 
[Parameter(mandatory=$true)][string] $InputFile = 'C:\posh\input\BACKUP.XLOG.log' # since I use the same file for testing , I should check against an expected output result
)

# param works as a script but does not come up when an executable. 
# That was because I had to select "Show PowerShell Console" when crearing the executable with PowerGUI


# "C:\hsgTest\projects\Get-EVVersion\Get-EVVersion08_06.ps1" based on working
# "C:\hsgTest\projects\Get-EVVersion\Get-EVVersion08_05.ps1" optimized Agent log parsing



# set Clipboard

. C:\posh\projects\Clipboard\Set-Clipboard_fc.ps1


# $log1 for Get-Content of it $log1 = Get-Content C:\hsgTest\input\Backup-526ABFBB-48AC-29B4.LOG

$AgentLog = New-Object PSObject
$AgentLog | Add-Member NoteProperty LogPath "C:\-"
$AgentLog | Add-Member NoteProperty LogName "-"
$AgentLog | Add-Member NoteProperty AgentVersion "-.-"
$AgentLog | Add-Member NoteProperty VaultVersion "-.-"
$AgentLog | Add-Member NoteProperty HostName "-"
$AgentLog | Add-Member NoteProperty IPAddress "-.-.-.-"
$AgentLog | Add-Member NoteProperty TaskName "-"
$AgentLog | Add-Member NoteProperty TaskGUID "-"
$AgentLog | Add-Member NoteProperty AgentGUID "-"
$AgentLog | Add-Member NoteProperty VaultGUID "-"

#, vid=4e354d4a-4d7b-49d7-8c9d-11de84e19bff, cid=9c269aa4-ee11-491c-956e-b076a507719a, tid=96336c5c-4aff-4485-a3b0-ca2f31499484


$log1 = Get-Content $InputFile

$AgentLog.LogPath = $log1[1].PSPath
$AgentLog.LogName = $log1[1].PSChildName


$A0 = @{key0 = " BKUP-I-04314";key1 = " ";key2 = " ";key3 = "Agent";key4 = "AgentVersion"}		# changed keyword " Agent Version" to " BKUP-I-04314" as in French it would Be "Version de L'agent"
$A1 = @{key0 = " BKUP-I-04315";key1 = " ";key2 = " ";key3 = "ault";key4 = "VaultVersion"}	# changed keyword " Vault Version" to " BKUP-I-04315" as in French it would Be "Version du vault" , note sub-filtering by ault As vault in english is upppercase V
$A2 = @{key0 = ", hn=";key1 = "=";key2 = ", ";key3 = "hn";key4 = "HostName"}
$A3 = @{key0 = ", ip=";key1 = "=";key2 = ", ";key3 = "ip";key4 = "IPAddress"}
$A4 = @{key0 = " tn=";key1 = "=";key2 = ", ";key3 = "tn";key4 = "TaskName"}
$A5 = @{key0 = ", tid=";key1 = "=";key2 = ", ";key3 = "tid";key4 = "TaskGUID"}
$A6 = @{key0 = ", cid=";key1 = "=";key2 = ", ";key3 = "cid";key4 = "AgentGUID"}
$A7 = @{key0 = ", vid=";key1 = "=";key2 = ", ";key3 = "vid";key4 = "VaultGUID"}




$Keys = @(
$A0,
$A1,
$A2,
$A3,
$A4,
$A5,
$A6,
$A7
)

for($counter = 0; $counter -lt $Keys.Length; $counter++){
	$a = $log1 | Where-Object {$_ -match $Keys[$counter].key0 } | ForEach-Object {$_.Split($Keys[$counter].key1)} | ForEach-Object {$_.Split($Keys[$counter].key2)}

	$i = 0
	foreach ($element in $a){
		$i++
		if ($element.Contains($Keys[$counter].key3)){
			$temp = $Keys[$counter].key4
			$AgentLog."$temp" = $a[$i]
		}
	}
}

# Use case
$AgentLog | Set-Clipboard
 
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