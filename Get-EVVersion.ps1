# working "C:\hsgTest\projects\Get-EVVersion\Get-EVVersion06_01.ps1" to get tid and paste results to clipboard

param ( 
[Parameter(mandatory=$true)][string] $InputFile
)

# param works as a script but does not come up when an executable. 
# That was because I had to select "Show PowerShell Console" when crearing the executable with PowerGUI


# "C:\hsgTest\projects\Get-EVVersion\Get-EVVersion06_01.ps1" based on working
# "C:\hsgTest\projects\Get-EVVersion\Get-EVVersion04_01.ps1" (- some Comments) with results:



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


# $log1 for Get-Content of it$log1 = Get-Content C:\hsgTest\input\BACKUP_filtered.XLOG

$VaultLog = New-Object PSObject
$VaultLog | Add-Member NoteProperty VaultName "-"
$VaultLog | Add-Member NoteProperty LogPath "-"
$VaultLog | Add-Member NoteProperty LogName "-"
$VaultLog | Add-Member NoteProperty TaskID "(-)"

$log1 = Get-Content $InputFile

$VaultLog.LogPath = $log1[1].PSPath

                                                                                                                                          
$log1[1].PSChildName
$a = $log1 | Where-Object {$_ -match ("tid= ") } | ForEach-Object {$_.Split(" ")}

$VaultLog.TaskID = $a[-1]

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
#HostName     : TMTC-SBS
#IPAddress    : 192.168.1.1
#TaskName     : TMTC-SBS-EXCH
#
#
