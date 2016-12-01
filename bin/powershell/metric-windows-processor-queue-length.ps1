#
#   metric-windows-processor-queue-length.ps1
#
# DESCRIPTION:
#   This plugin collects and outputs the Processor Queue Length in a Graphite acceptable format.
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
#   Powershell.exe -NonInteractive -NoProfile -ExecutionPolicy Bypass -NoLogo -File C:\\etc\\sensu\\plugins\\metric-windows-processor-queue-length.ps1
#
# NOTES:
#
# LICENSE:
#   Copyright 2016 sensu-plugins
#   Released under the same terms as Sensu (the MIT license); see LICENSE for details.
#
$ThisProcess = Get-Process -Id $pid
$ThisProcess.PriorityClass = "BelowNormal"

$Path = hostname
$Path = $Path.ToLower()

$Value = (Get-WmiObject Win32_PerfFormattedData_PerfOS_System).ProcessorQueueLength

$Time = [int][double]::Parse((Get-Date -UFormat %s))

Write-Host "$Path.system.processor_queue_length $Value $Time"
