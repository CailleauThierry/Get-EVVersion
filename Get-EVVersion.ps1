#in progress "C:\hsgTest\projects\Get-EVVersion\Get-EVVersion07_01.ps1" with input parameter an Agent log in txt format (save as txt from logviewer) and paste results to clipboard

param ( 
[Parameter(mandatory=$true)][string] $InputFile
)

# param works as a script but does not come up when an executable. 
# That was because I had to select "Show PowerShell Console" when crearing the executable with PowerGUI


# "C:\hsgTest\projects\Get-EVVersion\Get-EVVersion07_01.ps1" based on working
# "C:\hsgTest\projects\Get-EVVersion\Get-EVVersion06_02.ps1" tid to clipboard



#beginning of#################################################################
##
## Set-Clipboard
##
## From Windows PowerShell Cookbook (O'Reilly)
## by Lee Holmes (http://www.leeholmes.com/guide)
##
##############################################################################
Function Set-Clipboard {
<#

.SYNOPSIS

Sends the given input to the Windows clipboard.

.EXAMPLE

dir | Set-Clipboard
This example sends the view of a directory listing to the clipboard

.EXAMPLE

Set-Clipboard "Hello World"
This example sets the clipboard to the string, "Hello World".

#>

param(
    ## The input to send to the clipboard
    [Parameter(ValueFromPipeline = $true)]
    [object[]] $InputObject
)

begin
{
    Set-StrictMode -Version Latest
    $objectsToProcess = @()
}

process
{
    ## Collect everything sent to the script either through
    ## pipeline input, or direct input.
    $objectsToProcess += $inputObject
}

end
{
    ## Launch a new instance of PowerShell in STA mode.
    ## This lets us interact with the Windows clipboard.
    $objectsToProcess | PowerShell -NoProfile -STA -Command {
        Add-Type -Assembly PresentationCore

        ## Convert the input objects to a string representation
        $clipText = ($input | Out-String -Stream) -join "`r`n"

        ## And finally set the clipboard text
        [Windows.Clipboard]::SetText($clipText)
    }
}
}

#end of#######################################################################
##
## Set-Clipboard
##
## From Windows PowerShell Cookbook (O'Reilly)
## by Lee Holmes (http://www.leeholmes.com/guide)
##
##############################################################################


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


$log1 = Get-Content $InputFile
$VaultLog.LogPath = $log1[1].PSPath 
$VaultLog.LogName = $log1[1].PSChildName

#VaultName
$a = $log1 | Where-Object {$_ -match ("Vault: ") } | ForEach-Object {$_.Split(" ")}
$VaultLog.VaultName = $a[-1]

#VaultVersion
$a = $log1 | Where-Object {$_ -match ("EVault Software Director Version ") } | ForEach-Object {$_.Split(" ")}

#function to take the next value after "Version"
$i = 0
foreach ($element in $a){
	$i++
	if ($element.Contains("Version")){
		$VaultLog.VaultVersion = $a[$i]
	}
}

#AgentHostname
$a = $log1 | Where-Object {$_ -match ("hn = ") } | ForEach-Object {$_.Split(" ")}
$VaultLog.AgentHostname = $a[-1]

#AgentIP
$a = $log1 | Where-Object {$_ -match ("ip = ") } | ForEach-Object {$_.Split(" ")}
$VaultLog.AgentIP = $a[-1]

#AgentVersion
$a = $log1 | Where-Object {$_ -match ("Agent version is ") } | ForEach-Object {$_.Split(" ")}
$VaultLog.AgentVersion = $a[-1]

#TaskName
$a = $log1 | Where-Object {$_ -match ("tn = ") } | ForEach-Object {$_.Split(" ")}
$VaultLog.TaskName = $a[-1]

#TaskID
$a = $log1 | Where-Object {$_ -match ("tid= ") } | ForEach-Object {$_.Split(" ")}
$VaultLog.TaskID = $a[-1]

#SafesetNumber
$a = $log1 | Where-Object {$_ -match ("catalog number is ") } | ForEach-Object {$_.Split(" ")}
$VaultLog.SafesetNumber = $a[-1]

#$log1[1].PSChildName
#$a = $log1 | Where-Object {$_ -match ("tid= ") }
#$b = $a | ForEach-Object {$_.Split(" ")}
#$VaultLog.TaskID =$b[-1]  
#(362)


# Use case
# $AgentLog | ft *
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
