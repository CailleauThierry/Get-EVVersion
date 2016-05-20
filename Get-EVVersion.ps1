# Get-EVVersion03_1.ps1 > took a while to get Agent version. Learned Select-String will help me optimize the whole function

# "C:\hsgTest\projects\Get-EVVersion\Get-EVVersion03.ps1" based on working "C:\hsgTest\projects\Get-EVVersion\Get-EVVersion02.ps1" (- some Comments) with results:
#HostName                    IPAddress                   TaskName                    VaultVersion               LogPath                   
#--------                    ---------                   --------                    ------------               -------                   
#Host-1                    192.168.1.1                 Host-1-EXCH               7.01                       C:\hsgTest\input\BACKUP...

$log1 = Get-Content C:\hsgTest\input\BACKUP_filtered.XLOG

#opened "C:\hsgTest\projects\zip\1\zipoutput\Host-1-EXCH\BACKUP.XLOG" saved as clear text in "C:\hsgTest\input\BACKUP_filtered.XLOG"
# $log1 for Get-Content of it$log1 = Get-Content C:\hsgTest\input\BACKUP_filtered.XLOG

$AgentLog = New-Object PSObject
$AgentLog | Add-Member NoteProperty LogPath "C:\-"
$AgentLog | Add-Member NoteProperty AgentVersion "-.-"
$AgentLog | Add-Member NoteProperty VaultVersion "-.-"
$AgentLog | Add-Member NoteProperty HostName "-"
$AgentLog | Add-Member NoteProperty IPAddress "-.-.-.-"
$AgentLog | Add-Member NoteProperty TaskName "-"


$AgentLog.LogPath = $log1[0].PSPath

$a = $log1 | Where-Object {$_.Contains(" Agent Version ") -eq $true} | ForEach-Object {$_.Split(' ')} 

$b = $a | Select-string -Pattern "Version" -Context 0,1 | Select-Object -Unique

$AgentLog.AgentVersion = ($b.Context.PostContext)[0]

$AgentLog | ft *

#for ($i=0; $i -le $a.Length; $i++) {
#   $res = 
#}

# -------------------------- EXAMPLE 8 --------------------------
#
# C:\PS>$f = select-string -path audit.log -pattern "logon failed" -context 2, 3
#
# C:\PS> $f.count
#
# C:\PS> ($f)[0].context | format-list
#
#
# Description
# -----------
# The first command searches the Audit.Log file for the phrase "logon failed." It uses the Context parameter to capture 2 lines before the match and 3 lines after the match.
# The second command uses the Count property of object arrays to display the number of matches found, in this case, 2.
#
#The third command displays the lines stored in the Context property of the first MatchInfo object. It uses array notation to indicate the first match (match 0 in a zero-based
#array), and it uses the Format-List cmdlet to display the value of the Context property as a list.
#
#The output consists of two MatchInfo objects, one for each match detected. The context lines are stored in the Context property of the MatchInfo object.



# -------------------------- EXAMPLE 6 --------------------------
#
# C:\PS>$a = get-eventlog -log "Windows PowerShell"
#
# C:\PS> $a | select-object -index 0, ($a.count - 1)
#
#
# Description
# -----------
# These commands get the first (newest) and last (oldest) events in the Windows Powershell event log.
#
# The first command uses the Get-EventLog cmdlet to get all events in the Windows Powershell log. It saves the events in the $a variable.
## The second command uses a pipeline operator (|) to send the events in $a to the Select-Object cmdlet. The Select-Object command uses the Index parameter to select items by the
# index number. The index for the first event is 0. The index for the last event is the number of items in $a minus 1.


# $a | select ($_) > display each element of array $a

# I would like to be ableto do a foreach ($res in $a) $_.Text -eq Version $res=$a[+1]  > I want to catch the next entry after version

#$a | foreach {$a}  #there are 80 items in $a, it display all 80 items 80 time. It's like the first $a is just a counter

#$a[0]
#$a[1]
#$a[2]
#04-Dec
#21:30:02
#BKUP-I-04314

# $a = $log1 | Where-Object {$_.Contains(" Agent Version ") -eq $true} | ForEach-Object {$_.Split(' ')} 
#PS C:\Users\tcailleau\Documents> $a
#04-Dec
#21:30:02
#BKUP-I-04314
#Agent
#Version
#7.24.3120
#Oct
#24
#2013
#01:29:17
#05-Dec
#21:30:05
#BKUP-I-04314
#Agent
#Version
#7.24.3120
#Oct
#24
#2013
#01:29:17
#06-Dec
#21:30:07
#BKUP-I-04314
#Agent
#Version
#7.24.3120
#Oct
#24
#2013
#01:29:17
#07-Dec
#21:30:10
#BKUP-I-04314
#Agent
#Version
#7.24.3120
#Oct
#24
#2013
#01:29:17
#09-Dec
#21:30:18
#BKUP-I-04314
#Agent
#Version
#7.24.3120
#Oct
#24
#2013
#01:29:17
#10-Dec
#21:30:21
#BKUP-I-04314
#Agent
#Version
#7.24.3120
#Oct
#24
#2013
#01:29:17
#11-Dec
#21:30:26
#BKUP-I-04314
#Agent
#Version
#7.24.3120
#Oct
#24
#2013
#01:29:17
#12-Dec
#21:30:30
#BKUP-I-04314
#Agent
#Version
#7.24.3120
#Oct
#24
#2013
#01:29:17

#$log1 | Where-Object {$_.Contains(" Agent Version ") -eq $true} | Sort-Object -Unique | ForEach-Object {$_.Split(' Agent Version ')} 
#$AgentLog.AgentVersion = $a[-1]
