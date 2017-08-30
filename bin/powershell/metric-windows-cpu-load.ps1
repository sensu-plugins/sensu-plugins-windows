#
#   metric-windows-cpu-load.ps1
#
# DESCRIPTION:
#   This plugin collects and outputs the CPU Usage in a Graphite acceptable format.
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
#   Powershell.exe -NonInteractive -NoProfile -ExecutionPolicy Bypass -NoLogo -File C:\\etc\\sensu\\plugins\\metric-windows-cpu-load.ps1
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

$ThisProcess = Get-Process -Id $pid
$ThisProcess.PriorityClass = "BelowNormal"

$perfCategoryID = Get-PerformanceCounterByID -Name 'Processor Information'
$perfCounterID = Get-PerformanceCounterByID -Name '% Processor Time'

$localizedCategoryName = Get-PerformanceCounterLocalName -ID $perfCategoryID
$localizedCounterName = Get-PerformanceCounterLocalName -ID $perfCounterID

$Value = [System.Math]::Round((Get-Counter "\$localizedCategoryName(_total)\$localizedCounterName" -SampleInterval 1 -MaxSamples 1).CounterSamples.CookedValue)

$Path = [System.Net.Dns]::GetHostEntry([string]"localhost").HostName.toLower()

$Time = DateTimeToUnixTimestamp -DateTime (Get-Date)

Write-Host "$Path.cpu.total_time_percent $Value $Time"