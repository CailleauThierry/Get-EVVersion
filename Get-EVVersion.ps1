<#
	.SYNOPSIS
		Description still to come

	.DESCRIPTION
		Get-EVVersion10_00.ps1 based on working Get-EVVersion08_09.ps1  it uses the desktop shortcut as the wrapper. 
		This is the first attempt at regex re-write
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



param ( 
[Parameter(mandatory=$false)][string] $InputFile =  'C:\posh\input\backup_fr.xlog.log' #  since I use the same file for testing , I should check against an expected output result
)


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

$A0 = @{key0 = " BKUP-I-04314";key1 = '(?<RegExMatch>\d{1}.\d{2}.\d{4})';key2 = " ";key3 = "Version";key4 = "AgentVersion"}  # changed keyword " Agent Version" to " BKUP-I-04314" as in French it would Be "Version de l’Agent"
$A1 = @{key0 = " BKUP-I-04315";key1 = " ";key2 = " ";key3 = "Version";key4 = "VaultVersion"}  # changed keyword " Vault Version" to " BKUP-I-04315" as in French it would Be "Version du vault" , note sub-filtering by ault As vault in english is upppercase V
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
	$a = $log1 | Where-Object {$_ -match $Keys[$counter].key0 } | Where-Object {$_ -match  $Keys[$counter].key1} # | ForEach-Object {$_.Split($Keys[$counter].key1)} | ForEach-Object {$_.Split($Keys[$counter].key2)}
# if an element of the selected row contains the "pre-word" key3 (like Version, hn, tn...) then pick the next entry in the splitted line. This entry is store in an object with corresponding
# key4 Property (like AgentVersion, HostName, TaskName. This is the resulte of observer redundancies and size optimzation of the code
		$temp = $Keys[$counter].key4
		$AgentLog."$temp" = $Matches[0]

#	$i = 0
#	foreach ($element in $a){
#		$i++
#		if ($element.Contains($Keys[$counter].key3)){
#			$temp = $Keys[$counter].key4
#			$AgentLog."$temp" = $a[$i]
#		}
#	}
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