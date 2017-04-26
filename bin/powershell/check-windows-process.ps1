#
#   check-windows-process.ps1
#
# DESCRIPTION:
#   This plugin checks whether a User-inputted process is running or not.
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
#   Powershell.exe -NonInteractive -NoProfile -ExecutionPolicy Bypass -NoLogo -File C:\\etc\\sensu\\plugins\\check-windows-process.ps1
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
   [string]$ProcessName
)

$ThisProcess = Get-Process -Id $pid
$ThisProcess.PriorityClass = "BelowNormal"

$Exists = Get-Process $ProcessName -ErrorAction SilentlyContinue

If (!$Exists) {
  Write-Host CRITICAL: $ProcessName not found!
  Exit 2 }

If ($Exists) {
  Write-Host OK: $ProcessName running.
  Exit 0 }
