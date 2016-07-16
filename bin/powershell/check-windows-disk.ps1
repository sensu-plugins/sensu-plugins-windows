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
#   Powershell
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
[CmdletBinding()]
Param(
   [Parameter(Mandatory=$True,Position=1)] 
   [int]$WARNING,

   [Parameter(Mandatory=$True,Position=2)]
   [int]$CRITICAL,

# Example "abz"
   [Parameter(Mandatory=$False,Position=3)]
   [string]$IGNORE
)

$ThisProcess = Get-Process -Id $pid
$ThisProcess.PriorityClass = "BelowNormal"

If ($IGNORE -eq "") { $IGNORE = "ab" }

$BrownChickenBrownCow = 0

$AllDisks = Get-WMIObject Win32_LogicalDisk -Filter "DriveType = 3" | ? { $_.DeviceID -notmatch "[$IGNORE]:"}

foreach ($ObjDisk in $AllDisks) 
{ 
  $UsedPercentage = [System.Math]::Round(((($ObjDisk.Size-$ObjDisk.Freespace)/$ObjDisk.Size)*100),2)
  
  If ($UsedPercentage -gt $CRITICAL) {
    Write-Host CheckDisk CRITICAL: $ObjDisk.DeviceID $UsedPercentage%.
    $BrownChickenBrownCow = 2
  }

  ElseIf ($UsedPercentage -gt $WARNING) {
    Write-Host CheckDisk WARNING: $ObjDisk.DeviceID $UsedPercentage%.
    If ($BrownChickenBrownCow -ne 2) { $BrownChickenBrownCow = 1 }
  }
}

If ($BrownChickenBrownCow -eq 0) {
  Write-Host CheckDisk OK: All disk usage under $WARNING%.
  Exit $BrownChickenBrownCow
}

Else { Exit $BrownChickenBrownCow }
