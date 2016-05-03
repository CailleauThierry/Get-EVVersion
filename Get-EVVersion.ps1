#opened "C:\hsgTest\projects\zip\1\zipoutput\Host-1-EXCH\BACKUP.XLOG" saved as clear text in "C:\hsgTest\input\BACKUP_filtered.XLOG"
# $log1 for Get-Content of it
$log1 = Get-Content C:\hsgTest\input\BACKUP_filtered.XLOG

#PS C:\Users\tcailleau> $log1 | Where-Object {$_.Contains("hn=") -eq $true} | ForEach-Object {$_.Split(', ')}
#04-Dec
#21:30:40
#UTIL-I-05210
#Computer
#information:
#dn=Host
#
#hn=Host-1
#
#ip=192.168.1.1
#
#vid=4e354d4a-4d7b-49d7-8c9d-11de84e19bff
#
#cid=9c269aa4-ee11-491c-956e-b076a507719a
#[VV]

#PS C:\Users\tcailleau> $log1[0].PSPath
#
#C:\hsgTest\input\BACKUP_filtered.XLOG

#PS C:\Users\tcailleau> $sys1 = New-Object PSObject
#PS C:\Users\tcailleau> $sys1 | gm
#
#
#   TypeName: System.Management.Automation.PSCustomObject
#
#Name        MemberType Definition                    
#----        ---------- ----------                    
#Equals      Method     bool Equals(System.Object obj)
#GetHashCode Method     int GetHashCode()             
#GetType     Method     type GetType()                
#ToString    Method     string ToString()             
#
#
#PS C:\Users\tcailleau> $sys1 | Add-Member NoteProperty Hostname "-"
#PS C:\Users\tcailleau>                           help Add-Member -full
#PS C:\Users\tcailleau> $sys1 | Add-Member NoteProperty HostName "-"
#Add-Member : Cannot add a member with the name "HostName" because a member with that name already exists. If you want to overwrite the member anyway, use the Force parameter to ov
#erwrite it.
#At line:1 char:19
#+ $sys1 | Add-Member <<<<  NoteProperty HostName "-"
#    + CategoryInfo          : InvalidOperation: (@{Hostname=-}:PSObject) [Add-Member], InvalidOperationException
#    + FullyQualifiedErrorId : MemberAlreadyExists,Microsoft.PowerShell.Commands.AddMemberCommand
# 
#PS C:\Users\tcailleau> $sys1 | Add-Member NoteProperty HostName "-" -Force
#PS C:\Users\tcailleau> $sys1 | Add-Member NoteProperty IPAddress "-.-.-.-"
#PS C:\Users\tcailleau> $sys1 | Add-Member NoteProperty TaskName "-"
#PS C:\Users\tcailleau> $sys1 | Add-Member NoteProperty VaultVersion "-.-"
#PS C:\Users\tcailleau> $sys1 | Add-Member NoteProperty TaskID "-"
#PS C:\Users\tcailleau> $sys1
#
#
#HostName     : -
#IPAddress    : -.-.-.-
#TaskName     : -
#VaultVersion : -.-
#TaskID       : -
#
#
#
#PS C:\Users\tcailleau> $sys1 | ft *
#
#HostName                            IPAddress                           TaskName                            VaultVersion                        TaskID                             
#--------                            ---------                           --------                            ------------                        ------                             
#-                                   -.-.-.-                             -                                   -.-                                 -                                  
#
#
#PS C:\Users\tcailleau> $sys1 | Add-Member NoteProperty LogPath "C:\-"
#PS C:\Users\tcailleau> $sys1
#
#
#HostName     : -
#IPAddress    : -.-.-.-
#TaskName     : -
#VaultVersion : -.-
#TaskID       : -
#LogPath      : C:\-
#
#
#
#PS C:\Users\tcailleau> $sys1 | ft *
#
#HostName                      IPAddress                     TaskName                      VaultVersion                  TaskID                        LogPath                      
#--------                      ---------                     --------                      ------------                  ------                        -------                      
#
#-                             -.-.-.-                       -                             -.-                           -                             C:\-                 
#
$sys1 = New-Object PSObject
#PS C:\Users\tcailleau> $sys1 | gm
#
#
#   TypeName: System.Management.Automation.PSCustomObject
#
#Name        MemberType Definition                    
#----        ---------- ----------                    
#Equals      Method     bool Equals(System.Object obj)
#GetHashCode Method     int GetHashCode()             
#GetType     Method     type GetType()                
#ToString    Method     string ToString()             

$sys1 | Add-Member NoteProperty HostName "-"
$sys1 | Add-Member NoteProperty IPAddress "-.-.-.-"
$sys1 | Add-Member NoteProperty TaskName "-"
$sys1 | Add-Member NoteProperty VaultVersion "-.-"
$sys1 | Add-Member NoteProperty TaskID "-"
$sys1 | Add-Member NoteProperty LogPath "C:\-"

# Use case
$sys1 | ft *
#HostName                      IPAddress                     TaskName                      VaultVersion                  TaskID                        LogPath                      
#--------                      ---------                     --------                      ------------                  ------                        -------                      
#
#-                             -.-.-.-                       -                             -.-                           -                             C:\-                 