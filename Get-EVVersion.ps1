# in progress (works partially) to change function to take i/p from the clipboard
# partial result
#
#
#AgentVersion : -.-
#VaultVersion : 
#               
#HostName     : Host-1
#IPAddress    : 192.168.1.1
#TaskName     : Host-1-EXCH


#Work in progress to investiage :  Get-EVVersion03_1.ps1 highlights a Select-String better approach
# I did a focus in Get-EVVersion03_1.ps1 to Get AgentVersion working
# Aslo a good idea would simply take the clipboard input and then launch exe to paste back into clipboard
# "C:\hsgTest\projects\Get-EVVersion\Get-EVVersion05.ps1" based on working "C:\hsgTest\projects\Get-EVVersion\Get-EVVersion04.ps1" (- some Comments) with results:
#LogPath                  AgentVersion             VaultVersion             HostName                 IPAddress                TaskName       
#-------                  ------------             ------------             --------                 ---------                --------       
#C:\hsgTest\input\BACK... 7.24.3120                7.01                     Host-1                 192.168.1.1              Host-1-EXCH 


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

#beginning of#################################################################
##
## Get-Clipboard
##
## From Windows PowerShell Cookbook (O'Reilly)
## by Lee Holmes (http://www.leeholmes.com/guide)
##
##############################################################################
function Get-Clipboard([switch] $Lines) {
	if($Lines) {
		$cmd = {
			Add-Type -Assembly PresentationCore
			[Windows.Clipboard]::GetText() -replace "`r", '' -split "`n"
		}
	} else {
		$cmd = {
			Add-Type -Assembly PresentationCore
			[Windows.Clipboard]::GetText()
		}
	}
	if([threading.thread]::CurrentThread.GetApartmentState() -eq 'MTA') {
		& powershell -Sta -Command $cmd
	} else {
		& $cmd
	}
}


#end of#######################################################################
##
## Get-Clipboard
##
## From Windows PowerShell Cookbook (O'Reilly)
## by Lee Holmes (http://www.leeholmes.com/guide)
##
##############################################################################

$log1 = Get-Clipboard

#$log1

#opened "C:\hsgTest\projects\zip\1\zipoutput\Host-1-EXCH\BACKUP.XLOG" saved as clear text in "C:\hsgTest\input\BACKUP_filtered.XLOG"
# $log1 for Get-Content of it$log1 = Get-Content C:\hsgTest\input\BACKUP_filtered.XLOG

$AgentLog = New-Object PSObject
$AgentLog | Add-Member NoteProperty AgentVersion "-.-"
$AgentLog | Add-Member NoteProperty VaultVersion "-.-"
$AgentLog | Add-Member NoteProperty HostName "-"
$AgentLog | Add-Member NoteProperty IPAddress "-.-.-.-"
$AgentLog | Add-Member NoteProperty TaskName "-"

$a = $log1 | Where-Object {$_.Contains(" Vault Version ") -eq $true} | Sort-Object -Unique | ForEach-Object {$_.Split(' Vault Version ')} 
$AgentLog.VaultVersion = $a[-1]

# one difference is there is no need to split the Vault Version line

$a = $log1 | Where-Object {$_.Contains(" Agent Version ") -eq $true} | ForEach-Object {$_.Split(' ')} 

$b = $a | Select-string -Pattern "Version" -Context 0,1 | Select-Object -Unique

#$b
# Using Select-String was more efficient but extracting the result as a string took a bit of digging explaining the "$b.Context.PostContext)[0]"

$AgentLog.AgentVersion = ($b.Context.PostContext)[0]


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
