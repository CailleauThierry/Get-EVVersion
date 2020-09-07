﻿#beginning of#################################################################
##
## Set-Clipboard
##
## From Windows PowerShell Cookbook (O'Reilly)
## by Lee Holmes (http://www.leeholmes.com/guide)
##
## on 09_01_2020
## We are using .NET 4.0. We had the same problem, but after logging off the system, code used to work fine for some time.
## Finally we found the alternative.
## If you want to copy a string to the clipboard,
## string data = "Copy This"
## Till now I was using the following method
## Clipboard.SetText(data);
## It was failing again and again. Then I looked at other methods available to set text in the clipboard in Clipboard Class and tried the following:
## Clipboard.SetDataObject(data);
## And it worked :). I never had the issue again.
## From <https://stackoverflow.com/questions/12769264/openclipboard-failed-when-copy-pasting-data-from-wpf-datagrid> 
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
        [Windows.Clipboard]::SetDataObject($clipText)
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