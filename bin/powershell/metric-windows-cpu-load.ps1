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

$Time = DateTimeToUnixTimestamp -DateTime (Get-Date)

$value=(Get-CimInstance -ClassName Win32_PerfFormattedData_PerfOS_Processor -Filter "Name like '_Total'").PercentProcessorTime
Write-Host "$Path.cpu.percent.total $value $Time"

$value=(Get-CimInstance -ClassName Win32_PerfFormattedData_PerfOS_Processor -Filter "Name like '_Total'").PercentIdleTime
Write-Host "$Path.cpu.percent.idle $value $Time"

$value=(Get-CimInstance -ClassName Win32_PerfFormattedData_PerfOS_Processor -Filter "Name like '_Total'").PercentUserTime
Write-Host "$Path.cpu.percent.user $value $Time"

$value=(Get-CimInstance -ClassName Win32_PerfFormattedData_PerfOS_Processor -Filter "Name like '_Total'").PercentInterruptTime
Write-Host "$Path.cpu.percent.interrupt $value $Time"