#
#   check-windows-disk.ps1
#
# DESCRIPTION:
#   This plugin collects the Disk Usage and and compares against the WARNING and CRITICAL thresholds.
#
# OUTPUT:
#   plain text
#
# PLATFORMS:
#   Windows
#
# DEPENDENCIES:
#   Powershell 3.0 or above
#
# USAGE:
#   Powershell.exe -NonInteractive -NoProfile -ExecutionPolicy Bypass -NoLogo -File C:\\etc\\sensu\\plugins\\check-windows-disk.ps1 90 95 ab
#
# NOTES:
#  
# LICENSE:
#   Copyright 2016 sensu-plugins
#   Released under the same terms as Sensu (the MIT license); see LICENSE for details.
#

#Requires -Version 3.0

[CmdletBinding()]
Param(
  [Parameter(Mandatory=$True,Position=1)] 
  [int]$WARNING,

  [Parameter(Mandatory=$True,Position=2)]
  [int]$CRITICAL,

  # Example "abz"
  [Parameter(Mandatory=$False,Position=4)]
  [string]$IGNORE
)

$ThisProcess = Get-Process -Id $pid
$ThisProcess.PriorityClass = "BelowNormal"

If ($IGNORE -eq "") {
  $IGNORE = "ab" 
}

$AllDisks = Get-CimInstance -ClassName Win32_LogicalDisk -Filter "DriveType = 3" | Where-Object { $_.DeviceID -notmatch "[$IGNORE]:"}

$crit = 0
$warn = 0
$critDisks = ""
$warnDisks = ""

foreach ($ObjDisk in $AllDisks) {

  $UsedPercentage = [System.Math]::Round(((($ObjDisk.Size-$ObjDisk.Freespace)/$ObjDisk.Size)*100),2)
  $Free = [math]::truncate($ObjDisk.Freespace / 1GB)
  $Size = [math]::truncate($ObjDisk.Size / 1GB)
  $ID = $ObjDisk.DeviceID

  if ($UsedPercentage -ge $CRITICAL) {
    $crit += 1
    $critDisks += "($ID) $UsedPercentage%, FREE: $Free GB, SIZE: $Size GB `n"
  } elseif ($UsedPercentage -ge $WARNING) {
    $warn += 1
    $warnDisks += "($ID) $UsedPercentage%, FREE: $Free GB, SIZE: $Size GB `n"
  } 
}

if ($crit -ne 0) {
  if ($warn -ne 0 ){
    Write-Host "CheckDisk CRITICAL: $crit disks in critical state `n$critDisks;`n$warn disks in warning state:`n$warnDisks"
  } else {
    Write-Host "CheckDisk CRITICAL: $crit disks in critical state `n$critDisks"
  }
  exit 2
} elseif ($warn -ne 0) {
  Write-Host "CheckDisk WARNING: $warn disks in warning state `n$warnDisks"
  exit 1
} 
  
Write-Host "CheckDisk OK: All disk usage under $WARNING%."
Exit 0