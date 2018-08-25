#
#   check-windows-processor-queue-length.ps1
#
# DESCRIPTION:
#   This plugin collects the Processor Queue Length and compares against the WARNING and CRITICAL thresholds.
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
#   Powershell.exe -NonInteractive -NoProfile -ExecutionPolicy Bypass -NoLogo -File C:\\etc\\sensu\\plugins\\check-windows-processor-queue-length.ps1 5 10
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

$Value = (Get-CimInstance -className Win32_PerfFormattedData_PerfOS_System).ProcessorQueueLength

If ($Value -gt $CRITICAL) {
  Write-Host CheckWindowsProcessorQueueLength CRITICAL: Processor Queue at $Value.
  Exit 2 }

If ($Value -gt $WARNING) {
  Write-Host CheckWindowsProcessorQueueLength WARNING: Processor Queue at $Value.
  Exit 1 }

Else {
  Write-Host CheckWindowsProcessorQueueLength OK: Processor Queue at $Value.
  Exit 0 }
