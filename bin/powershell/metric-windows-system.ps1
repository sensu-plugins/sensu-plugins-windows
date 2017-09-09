#
#   metric-windows-system.ps1
#
# DESCRIPTION:
#   This plugin collects and outputs some System Perfomance Counters in a Graphite acceptable format.
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
#   Powershell.exe -NonInteractive -NoProfile -ExecutionPolicy Bypass -NoLogo -File C:\\etc\\sensu\\plugins\\metric-windows-sytem.ps1
#
# NOTES:
#
# LICENSE:
#   Copyright 2016 sensu-plugins
#   Released under the same terms as Sensu (the MIT license); see LICENSE for details.
#

param(
    [switch]$UseFullyQualifiedHostname
    )

$ThisProcess = Get-Process -Id $pid
$ThisProcess.PriorityClass = "BelowNormal"

. (Join-Path $PSScriptRoot perfhelper.ps1)

if ($UseFullyQualifiedHostname -eq $false) {
    $Path = ($env:computername).ToLower()
}else {
    $Path = [System.Net.Dns]::GetHostEntry([string]"localhost").HostName.toLower()
}

$perfCategoryID = Get-PerformanceCounterByID -Name 'Processor Information'
$localizedCategoryName = Get-PerformanceCounterLocalName -ID $perfCategoryID
$perfCounterID = Get-PerformanceCounterByID -Name 'Interrupts/sec'
$localizedCounterName = Get-PerformanceCounterLocalName -ID $perfCounterID
$count_interrupt = [System.Math]::Round((Get-Counter "\$localizedCategoryName(_total)\$localizedCounterName" -SampleInterval 1 -MaxSamples 1).CounterSamples.CookedValue)

$perfCategoryID = Get-PerformanceCounterByID -Name 'System'
$localizedCategoryName = Get-PerformanceCounterLocalName -ID $perfCategoryID
$perfCounterID = Get-PerformanceCounterByID -Name 'Context Switches/sec'
$localizedCounterName = Get-PerformanceCounterLocalName -ID $perfCounterID
$count_context = [System.Math]::Round((Get-Counter "\$localizedCategoryName\$localizedCounterName" -SampleInterval 1 -MaxSamples 1).CounterSamples.CookedValue)

$Time = DateTimeToUnixTimestamp -DateTime (Get-Date)

Write-Host "$Path.system.irq_per_second $count_interrupt $Time"
Write-Host "$Path.system.context_switches_per_second $count_context $Time"
