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
#   Powershell 3.0 or above
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

$ThisProcess = Get-Process -Id $pid
$ThisProcess.PriorityClass = "BelowNormal"

. (Join-Path $PSScriptRoot perfhelper.ps1)

$ThisProcess = Get-Process -Id $pid
$ThisProcess.PriorityClass = "BelowNormal"

$perfCategoryID = Get-PerformanceCounterByID -Name 'Processor Information'
$localizedCategoryName = Get-PerformanceCounterLocalName -ID $perfCategoryID

$perfCounterID = Get-PerformanceCounterByID -Name '% Processor Time'
$localizedCounterName = Get-PerformanceCounterLocalName -ID $perfCounterID
$percent_total = [System.Math]::Round((Get-Counter "\$localizedCategoryName(_total)\$localizedCounterName" -SampleInterval 1 -MaxSamples 1).CounterSamples.CookedValue)

$perfCounterID = Get-PerformanceCounterByID -Name '% Idle Time'
$localizedCounterName = Get-PerformanceCounterLocalName -ID $perfCounterID
$percent_idle = [System.Math]::Round((Get-Counter "\$localizedCategoryName(_total)\$localizedCounterName" -SampleInterval 1 -MaxSamples 1).CounterSamples.CookedValue)

$perfCounterID = Get-PerformanceCounterByID -Name '% User Time'
$localizedCounterName = Get-PerformanceCounterLocalName -ID $perfCounterID
$percent_user = [System.Math]::Round((Get-Counter "\$localizedCategoryName(_total)\$localizedCounterName" -SampleInterval 1 -MaxSamples 1).CounterSamples.CookedValue)

$perfCounterID = Get-PerformanceCounterByID -Name '% Interrupt Time'
$localizedCounterName = Get-PerformanceCounterLocalName -ID $perfCounterID
$percent_interrupt = [System.Math]::Round((Get-Counter "\$localizedCategoryName(_total)\$localizedCounterName" -SampleInterval 1 -MaxSamples 1).CounterSamples.CookedValue)


# Select here whether the hostname is to be printed with or without domain
# Select here whether the hostname is to be printed with or without domain
# Default: Without Domain
# With Domain:
# $Path = [System.Net.Dns]::GetHostEntry([string]"localhost").HostName.toLower()

$Path = ($env:computername).ToLower() 

$Time = DateTimeToUnixTimestamp -DateTime (Get-Date)

Write-Host "$Path.cpu.percent.total $percent_total $Time"
Write-Host "$Path.cpu.percent.idle $percent_idle $Time"
Write-Host "$Path.cpu.percent.user $percent_user $Time"
Write-Host "$Path.cpu.percent.irq $percent_interrupt $Time"
