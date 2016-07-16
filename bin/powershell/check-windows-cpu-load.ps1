#
#   check-windows-cpu-load.ps1
#
# DESCRIPTION:
#   This plugin collects the CPU Usage and compares against the WARNING and CRITICAL thresholds.
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
#   Powershell.exe -NonInteractive -NoProfile -ExecutionPolicy Bypass -NoLogo -File C:\\etc\\sensu\\plugins\\check-windows-cpu-load.ps1 90 95
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
   [int]$CRITICAL
)

$ThisProcess = Get-Process -Id $pid
$ThisProcess.PriorityClass = "BelowNormal"

$Value = (Get-WmiObject CIM_Processor).LoadPercentage

If ($Value -gt $CRITICAL) {
  Write-Host CheckWindowsCpuLoad CRITICAL: CPU at $Value%.
  Exit 2 }

If ($Value -gt $WARNING) {
  Write-Host CheckWindowsCpuLoad WARNING: CPU at $Value%.
  Exit 1 }

Else {
  Write-Host CheckWindowsCpuLoad OK: CPU at $Value%.
  Exit 0 }
