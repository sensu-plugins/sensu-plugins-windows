#
#   check-windows-ram.ps1
#
# DESCRIPTION:
#   This plugin collects the RAM Usage and compares against the WARNING and CRITICAL thresholds.
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
#   Powershell.exe -NonInteractive -NoProfile -ExecutionPolicy Bypass -NoLogo -File C:\\etc\\sensu\\plugins\\check-windows-ram.ps1 90 95
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

$Memory = (Get-CimInstance -ClassName Win32_OperatingSystem)

$Value = [System.Math]::Round(((($Memory.TotalVisibleMemorySize-$Memory.FreePhysicalMemory)/$Memory.TotalVisibleMemorySize)*100),2)

If ($Value -ge $CRITICAL) {
  Write-Host CheckWindowsRAMLoad CRITICAL: RAM at $Value%.
  Exit 2 }

If ($Value -ge $WARNING) {
  Write-Host CheckWindowsRAMLoad WARNING: RAM at $Value%.
  Exit 1 }

Else {
  Write-Host CheckWindowsRAMLoad OK: RAM at $Value%.
  Exit 0 }
