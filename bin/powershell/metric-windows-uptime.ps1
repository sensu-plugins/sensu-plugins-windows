#
#   metric-windows-uptime.ps1
#
# DESCRIPTION:
#   This plugin collects and outputs the Uptime in seconds in a Graphite acceptable format.
#
# OUTPUT:
#   metric data
#
# PLATFORMS:
#   Windows
#
# DEPENDENCIES:
#   Powershell
#
# USAGE:
#   Powershell.exe -NonInteractive -NoProfile -ExecutionPolicy Bypass -NoLogo -File C:\\etc\\sensu\\plugins\\metric-windows-uptime.ps1
#
# NOTES:
#
# LICENSE:
#   Copyright 2016 sensu-plugins
#   Released under the same terms as Sensu (the MIT license); see LICENSE for details.
#
$ThisProcess = Get-Process -Id $pid
$ThisProcess.PriorityClass = "BelowNormal"

. (Join-Path $PSScriptRoot perfhelper.ps1)

$perfCategoryID = Get-PerformanceCounterByID -Name 'System'
$localizedCategoryName = Get-PerformanceCounterLocalName -ID $perfCategoryID

$perfCounterID = Get-PerformanceCounterByID -Name 'System Up Time'
$localizedCounterName = Get-PerformanceCounterLocalName -ID $perfCounterID

$Counter = ((Get-Counter "\$localizedCategoryName\$localizedCounterName").CounterSamples)

$Path = ($Counter.Path).Trim("\\") -replace " ","_" -replace "\\","." -replace "[\{\}]","" -replace "[\[\]]",""
$Value = [System.Math]::Truncate($Counter.CookedValue)
$Time = DateTimeToUnixTimestamp -DateTime (Get-Date)

Write-Host "$Path $Value $Time"
