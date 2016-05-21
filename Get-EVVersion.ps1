<#
	.SYNOPSIS
		Description still to come

	.DESCRIPTION
		Get-EVVersion10_03.ps1 based on working Get-EVVersion10_02.ps1. Code cleanup. Now also tested on Restore logs even Synch logs
		It uses the desktop shortcut as the wrapper. 
		Also could add multiple reccurence of the same entry in a different PropertyName
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
[Parameter(mandatory=$false)][string] $InputFile  =  'C:\Users\tcailleau\Documents\EMEA_files\Temp\006xxxxx\0062xxxx\00623507\support-bundle-20150128-092837\support-bundle-20150128-092837\support-bundle-20150128-092837\agent\BUAgent\Misc_1\RST20150116-133438.XLOG.log' #  since I use the same file for testing , I should check against an expected output result
)


# set Clipboard

. C:\posh\projects\Clipboard\Set-Clipboard_fc.ps1


# $log1 for Get-Content of it $log1 = Get-Content C:\hsgTest\input\Backup-526ABFBB-48AC-29B4.LOG

$AgentLog = New-Object PSObject
$AgentLog | Add-Member NoteProperty LogPath "C:\-"
$AgentLog | Add-Member NoteProperty LogName "-"
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

$A0 = @{key0 = "-I-04314";key1 = '(\s)(?<RegExMatch>(\d{1}\.\d{2}\.\d{4}))';key2 = "AgentVersion"}  # " BKUP-I-04314" same code as" REST-I-04314" so chnaging it to "-I-04314" only
$A1 = @{key0 = "-I-04315";key1 = '(\s)(?<RegExMatch>(\d{1}\.\d{2}))';key2 = "VaultVersion"}  # changed keyword " Vault Version" to " BKUP-I-04315" as in French it would Be "Version du vault" , note sub-filtering by ault As vault in english is upppercase V
$A2 = @{key0 =  " hn=";key1 =  '(hn=)(?<RegExMatch>(.*?))[,\s]\s*';key2 = "HostName"} # RegEx tested on http://rubular.com/ (.*?) where "?" means relunctant (matches only once) as oppose to greedy. See http://groovy.codehaus.org/Tutorial+5+-+Capturing+regex+groups> 
$A3 = @{key0 =  " ip=";key1 = '(ip=)(?<RegExMatch>(\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}))';key2 = "IPAddress"} # '(ip=)' is not needed here but it looks consistent with previous (hn=)
$A4 = @{key0 =  " tn=";key1 =  '(tn=)(?<RegExMatch>(.*?))[,\s]\s*';key2 = "TaskName"}
$A5 = @{key0 = " tid=";key1 = '(tid=)(?<RegExMatch>(\w{8}\-\w{4}\-\w{4}\-\w{4}\-\w{12}))';key2 = "TaskGUID"}
$A6 = @{key0 = " cid=";key1 = '(cid=)(?<RegExMatch>(\w{8}\-\w{4}\-\w{4}\-\w{4}\-\w{12}))';key2 = "AgentGUID"}  # there is no "," at the end of the first cid
$A7 = @{key0 = " vid=";key1 = '(vid=)(?<RegExMatch>(\w{8}\-\w{4}\-\w{4}\-\w{4}\-\w{12}))';key2 = "VaultGUID"}  # since guid are a set format, I do not need to match the "," at the end




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
	$a = $log1 | Where-Object {$_ -match $Keys[$counter].key0 } | Where-Object {$_ -match  $Keys[$counter].key1}

# key2 Property (like AgentVersion, HostName, TaskName. This is the resulte of observer redundancies and size optimzation of the code
		$temp = $Keys[$counter].key2
		$AgentLog."$temp" = $Matches[2]


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