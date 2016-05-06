# This is a working solution but Get-EVVersion03_1.ps1 highlights a Select-String better approach

# I did a focus in Get-EVVersion03_1.ps1 to Get AgentVersion working

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

# Using Select-String was more efficient but extracting the result as a string took a bit of digging explaining the "$b.Context.PostContext)[0]"

$AgentLog.AgentVersion = ($b.Context.PostContext)[0]

$a = $log1 | Where-Object {$_.Contains(" Vault Version ") -eq $true} | Sort-Object -Unique | ForEach-Object {$_.Split(' Vault Version ')} 
$AgentLog.VaultVersion = $a[-1]

# one difference is there is no need to split the Vault Version line
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
$AgentLog | ft *