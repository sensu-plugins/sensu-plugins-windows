#
#   check-windows-pagefile.ps1
#
# DESCRIPTION:
#   This plugin collects the Pagefile Usage and compares against the WARNING and CRITICAL thresholds.
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
#   Powershell.exe -NonInteractive -NoProfile -ExecutionPolicy Bypass -NoLogo -File C:\\opt\\sensu\\plugins\\check-windows-pagefile.ps1 75 85
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
   [int]$CRITICAL
)

$ThisProcess = Get-Process -Id $pid
$ThisProcess.PriorityClass = "BelowNormal"

[int]$pagefileAllocated = (Get-CimInstance -classname Win32_PageFileUsage).AllocatedBaseSize
[int]$pagefileCurrentUsage = (Get-CimInstance -classname Win32_PageFileUsage).CurrentUsage

[int]$Value = ($pagefileCurrentUsage/$pagefileAllocated) * 100

If ($Value -gt $CRITICAL) {
  Write-Host CheckWindowsPagefile CRITICAL: Pagefile usage at $Value%.
  Exit 2 }

If ($Value -gt $WARNING) {
  Write-Host CheckWindowsPagefile WARNING: Pagefile usage at $Value%.
  Exit 1 }

Else {
  Write-Host CheckWindowsPagefile OK: Pagefile usage at $Value%.
  Exit 0 }
