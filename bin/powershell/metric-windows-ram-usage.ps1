#
#   metric-windows-ram-usage.ps1
#
# DESCRIPTION:
#   This plugin collects and outputs the Ram Usage in a Graphite acceptable format.
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
#   Powershell.exe -NonInteractive -NoProfile -ExecutionPolicy Bypass -NoLogo -File C:\\etc\\sensu\\plugins\\metric-windows-ram-usage.ps1
#
# NOTES:
#
# LICENSE:
#   Copyright 2016 sensu-plugins
#   Released under the same terms as Sensu (the MIT license); see LICENSE for details.
#
$ThisProcess = Get-Process -Id $pid
$ThisProcess.PriorityClass = "BelowNormal"

$FreeMemory = (Get-WmiObject -Query "SELECT TotalVisibleMemorySize, FreePhysicalMemory FROM Win32_OperatingSystem").FreePhysicalMemory
$TotalMemory = (Get-WmiObject -Query "SELECT TotalVisibleMemorySize, FreePhysicalMemory FROM Win32_OperatingSystem").TotalVisibleMemorySize

$Path = (hostname).ToLower()
$Value = [System.Math]::Round(((($TotalMemory-$FreeMemory)/$TotalMemory)*100),2)
$Time = [int][double]::Parse((Get-Date -UFormat %s))

Write-host "$Path.system.ram.RamUsagePercent $Value $Time"
