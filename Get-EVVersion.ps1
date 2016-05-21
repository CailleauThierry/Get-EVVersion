<#
	.SYNOPSIS
		Description still to come

	.DESCRIPTION
		Get-EVVersion10_05.ps1 based on working Get-EVVersion10_04.ps1 which adds a timestamp. This timestamp might not be convenient for the rest of the process.
		I want to add multiple reccurence of the same entry in a different PropertyName
		It uses the desktop shortcut as the wrapper. 
		
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
[Parameter(mandatory=$false)][string] $InputFile  =  'C:\posh\input\BACKUP.XLOG.log' #  since I use the same file for testing , I should check against an expected output result
)


# set Clipboard

. C:\posh\projects\Clipboard\Set-Clipboard_fc.ps1


# $log1 for Get-Content of it $log1 = Get-Content C:\hsgTest\input\Backup-526ABFBB-48AC-29B4.LOG

$AgentLog = New-Object PSObject
$AgentLog | Add-Member NoteProperty LogPath "C:\-"
$AgentLog | Add-Member NoteProperty LogName "-"
$AgentLog | Add-Member NoteProperty TimeStamp "dd-mmm hh:mm:ss"
$AgentLog | Add-Member NoteProperty AgentVersion "-.--.----"
$AgentLog | Add-Member NoteProperty VaultVersion "-.--"
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

# key0 : line identifier key1 : RegEx Expression Matching for key0 identifier key2 is the PSObject Property Name associated with key0 identifier
$A0 = @{key0 = '(^)((\d{2}\-\w{3}))';key1 = '(^)(?<RegExMatch>(\d{2}\-\w{3}\s\d{2}:\d{2}:\d{2}))';key2 = "TimeStamp"}  # '(^)(?<RegExMatch>(\d{2}\-\w{3}\s\d{2}:\d{2}:\d{2}))' matching format '04-Dec 21:30:02'
$A1 = @{key0 = "-I-04314";key1 = '(\s)(?<RegExMatch>(\d{1}\.\d{2}\.\d{4}))';key2 = "AgentVersion"}  # " BKUP-I-04314" same code as" REST-I-04314" so chnaging it to "-I-04314" only
$A2 = @{key0 = "-I-04315";key1 = '(\s)(?<RegExMatch>(\d{1}\.\d{2}))';key2 = "VaultVersion"}  # changed keyword " Vault Version" to " BKUP-I-04315" as in French it would Be "Version du vault" , note sub-filtering by ault As vault in english is upppercase V
$A3 = @{key0 =  " hn=";key1 =  '(hn=)(?<RegExMatch>(.*?))[,\s]\s*';key2 = "HostName"} # RegEx tested on http://rubular.com/ (.*?) where "?" means relunctant (matches only once) as oppose to greedy. See http://groovy.codehaus.org/Tutorial+5+-+Capturing+regex+groups> 
$A4 = @{key0 =  " ip=";key1 = '(ip=)(?<RegExMatch>(\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}))';key2 = "IPAddress"} # '(ip=)' is not needed here but it looks consistent with previous (hn=)
$A5 = @{key0 =  " tn=";key1 =  '(tn=)(?<RegExMatch>(.*?))[,\s]\s*';key2 = "TaskName"}
$A6 = @{key0 = " tid=";key1 = '(tid=)(?<RegExMatch>(\w{8}\-\w{4}\-\w{4}\-\w{4}\-\w{12}))';key2 = "TaskGUID"}
$A7 = @{key0 = " cid=";key1 = '(cid=)(?<RegExMatch>(\w{8}\-\w{4}\-\w{4}\-\w{4}\-\w{12}))';key2 = "AgentGUID"}  # there is no "," at the end of the first cid
$A8 = @{key0 = " vid=";key1 = '(vid=)(?<RegExMatch>(\w{8}\-\w{4}\-\w{4}\-\w{4}\-\w{12}))';key2 = "VaultGUID"}  # since guid are a set format, I do not need to match the "," at the end




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
	$log1 | Where-Object {$_ -match $Keys[$counter].key0 } | ForEach-Object -Process {
		$_ -match  $Keys[$counter].key1
		$temp = $Keys[$counter].key2
		$Proper = $temp + $Matches.Count		# this only provide the total count of matching object here 4 since there are 4 backup logs in 1
		$AgentLog | Add-Member NoteProperty "$Proper" $Matches[2]
	}
}

# Use case
$AgentLog | Set-Clipboard
 
#Once pasted from clipboard the result is:
#
#
#LogPath      : C:\posh\input\BACKUP.XLOG.log
#LogName      : BACKUP.XLOG.log
#AgentVersion : 7.24.9012
#VaultVersion : 7.01
#HostName     : Host-1
#IPAddress    : 192.168.1.1
#TaskName     : Host-1-EXCH
#TaskGUID     : 96336c5c-4aff-4485-a3b0-ca2f31499484
#AgentGUID    : 9c269aa4-ee11-491c-956e-b076a507719a
#VaultGUID    : 4e354d4a-4d7b-49d7-8c9d-11de84e19bff


