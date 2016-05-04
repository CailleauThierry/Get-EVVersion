# working "C:\hsgTest\projects\Get-EVVersion\Get-EVVersion02.ps1" with results:
#HostName                    IPAddress                   TaskName                    VaultVersion               LogPath                   
#--------                    ---------                   --------                    ------------               -------                   
#Host-1                    192.168.1.1                 Host-1-EXCH               7.01                       C:\hsgTest\input\BACKUP...


#opened "C:\hsgTest\projects\zip\1\zipoutput\Host-1-EXCH\BACKUP.XLOG" saved as clear text in "C:\hsgTest\input\BACKUP_filtered.XLOG"
# $log1 for Get-Content of it
$log1 = Get-Content C:\hsgTest\input\BACKUP_filtered.XLOG

#PS C:\Users\tcailleau> $log1 | Select-Object {$_.Contains("hn=") -eq $true} | ForEach-Object {$_.Split(', ')} | Where-Object {$_.Contains("hn=") -eq $true}
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
# $sys1 | Add-Member NoteProperty TaskID "-" # TaskID is not defined on Agent side. This will become relevant for the Vault logs
$sys1 | Add-Member NoteProperty LogPath "C:\-"

# Use case
#$sys1 | ft *
#HostName                      IPAddress                     TaskName                      VaultVersion                  TaskID                        LogPath                      
#--------                      ---------                     --------                      ------------                  ------                        -------                      
#
#-                             -.-.-.-                       -                             -.-                           -                             C:\-                 

$sys1.LogPath = $log1[0].PSPath

#PS C:\windows\system32> $sys1 | gm
#
#
#   TypeName: System.Management.Automation.PSCustomObject
#
#Name         MemberType   Definition                                                 
#----         ----------   ----------                                                 
#Equals       Method       bool Equals(System.Object obj)                             
#GetHashCode  Method       int GetHashCode()                                          
#GetType      Method       type GetType()                                             
#ToString     Method       string ToString()                                          
#HostName     NoteProperty System.String HostName=-                                   
#IPAddress    NoteProperty System.String IPAddress=-.-.-.-                            
#LogPath      NoteProperty System.String LogPath=C:\hsgTest\input\BACKUP_filtered.XLOG
#TaskID       NoteProperty System.String TaskID=-                                     
#TaskName     NoteProperty System.String TaskName=-                                   
#VaultVersion NoteProperty System.String VaultVersion=-.-           

$a = $log1 | Where-Object {$_.Contains("hn=") -eq $true} | ForEach-Object {$_.Split(', ')} | Where-Object {$_.Contains("hn=") -eq $true} | Sort-Object -Unique | ForEach-Object {$_.Split('hn=')} 

#PS C:\windows\system32> $a
#
#
#
#Host-1

$sys1.HostName = $a[-1]

#PS C:\windows\system32> $sys1
#
#
#HostName     : Host-1
#IPAddress    : -.-.-.-
#TaskName     : -
#VaultVersion : -.-
#TaskID       : -
#LogPath      : C:\hsgTest\input\BACKUP_filtered.XLOG

$a = $log1 | Where-Object {$_.Contains("hn=") -eq $true} | ForEach-Object {$_.Split(', ')} | Where-Object {$_.Contains("ip=") -eq $true} | Sort-Object -Unique | ForEach-Object {$_.Split('ip=')} 

$sys1.IPAddress = $a[-1]

#PS C:\windows\system32> $a = $log1 | Where-Object {$_.Contains("hn=") -eq $true} | ForEach-Object {$_.Split(', ')} | Where-Object {$_.Contains("ip=") -eq $true} | Sort-Object -Unique | ForEach-Object {$_.Split('ip=')} 
#
#PS C:\windows\system32> $a
#
#
#
#192.168.1.1
#PS C:\windows\system32> $sys1.IPAddress = $a[-1]
#PS C:\windows\system32> $sys1
#
#
#HostName     : Host-1
#IPAddress    : 192.168.1.1
#TaskName     : -
#VaultVersion : -.-
#TaskID       : -
#LogPath      : C:\hsgTest\input\BACKUP_filtered.XLOG

$a = $log1 | Where-Object {$_.Contains("tn=") -eq $true} | ForEach-Object {$_.Split(', ')} | Where-Object {$_.Contains("tn=") -eq $true} | Sort-Object -Unique | ForEach-Object {$_.Split('tn=')} 
$sys1.TaskName = $a[-1]

#PS C:\windows\system32> $a = $log1 | Where-Object {$_.Contains("tn=") -eq $true} | ForEach-Object {$_.Split(', ')} | Where-Object {$_.Contains("tn=") -eq $true} | Sort-Object -Unique | ForEach-Object {$_.Split('tn=')} 
#PS C:\windows\system32> $a
#
#
#
#Host-1-EXCH
#PS C:\windows\system32> $sys1.TaskName = $a[-1]
#PS C:\windows\system32> $sys1
#
#
#HostName     : Host-1
#IPAddress    : 192.168.1.1
#TaskName     : Host-1-EXCH
#VaultVersion : -.-
#TaskID       : -
#LogPath      : C:\hsgTest\input\BACKUP_filtered.XLOG

$a = $log1 | Where-Object {$_.Contains(" Vault Version ") -eq $true} | Sort-Object -Unique | ForEach-Object {$_.Split(' Vault Version ')} 
$sys1.VaultVersion = $a[-1]

# one difference is there is no need to split the Vault Version line
#PS C:\windows\system32> $a = $log1 | Where-Object {$_.Contains(" Vault Version ") -eq $true} | Sort-Object -Unique | ForEach-Object {$_.Split(' Vault Version ')} 
#
#PS C:\windows\system32> $sys1.VaultVersion = $a[-1]
#PS C:\windows\system32> $sys1
#
#
#HostName     : Host-1
#IPAddress    : 192.168.1.1
#TaskName     : Host-1-EXCH
#VaultVersion : 7.01
#LogPath      : C:\hsgTest\input\BACKUP_filtered.XLOG


# Use case
$sys1 | ft *