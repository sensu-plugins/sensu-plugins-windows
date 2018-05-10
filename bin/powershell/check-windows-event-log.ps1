 <#
.SYNOPSIS 
    Returns all occurances of pattern in log file 
.DESCRIPTION
    Checks Event log for pattern and returns the number criticals and warnings that match that pattern. 
.Notes
    FileName    : check-windows-event-log.ps1
    Author      : Patrice White - patrice.white@ge.com
.LINK 
    https://github.com/sensu-plugins/sensu-plugins-windows
.PARAMETER LogName 
    Required. The name of the log file.
    Example -LogName Application
.PARAMETER Pattern
    Required. The pattern you want to search for.
    Example -LogName Application -Pattern error
.EXAMPLE
    powershell.exe -file check-windows-log.ps1 -LogName Application -Pattern error
#>

[CmdletBinding()]
Param(
  [Parameter(Mandatory=$True)]
  [string]$LogName,
  [Parameter(Mandatory=$True)]
  [string]$Pattern
)

#Search for pattern inside of File
$ThisEvent = Get-WinEvent $LogName -ErrorAction SilentlyContinue | Where {$_.Message -like "*$($Pattern)*"}

If($ThisEvent -ne $null ){
  $ThisEvent
}

#Counts the number of criticals and warnings
$CountCrits=($ThisEvent | Where{$_.LevelDisplayName -eq 'Critical'}).count
$CountWarns=($ThisEvent | Where{$_.LevelDisplayName -eq 'Warning'}).count

#Prints count of how many ciritials and warnings
If($CountCrits -eq 0 -And $CountWarns -eq 0){
  "CheckLog OK: $CountCrits criticals $CountWarns warnings"
   EXIT 0
}ElseIF ($CountCrits -gt 0) {
    "CheckLog CRITICAL: $CountCrits criticals $CountWarns warnings"
    EXIT 2
}
Else {
    "CheckLog WARNING: $CountCrits criticals $CountWarns warnings"
    EXIT 1
}
