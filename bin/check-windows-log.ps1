<#
.SYNOPSIS 
    Returns all occurances of pattern in log file 
.DESCRIPTION
    Checks log file for pattern and returns line(s) containing pattern
.Notes
    FileName    : check-windows-log.ps1
    Author      : Patrice White - patrice.white@ge.com
.LINK 
    https://github.com/sensu-plugins/sensu-plugins-windows
.PARAMETER LogName 
    Required. The name of the log file.
    Example -LogName example.log
.PARAMETER Pattern
    Required. The pattern you want to search for.
    Example -LogName example.log -Pattern error
.EXAMPLE
    powershell.exe -file check-windows-log.ps1 -LogPath example.log -Pattern error
#>

[CmdletBinding()]
Param(
  [Parameter(Mandatory=$True)]
  [string]$LogPath,
  [Parameter(Mandatory=$True)]
  [string]$Pattern
)

#Search for pattern inside of File
$ThisLog = Select-String -Path $LogPath -Pattern $Pattern -AllMatch

#Show matched lines if they exist
If($ThisLog -eq $null ){
  "CheckLog OK: The pattern doesn't exist in log"
  EXIT 0
}else{
  $ThisLog
  "CheckLog CRITICAL"
  EXIT 2
}
