#
#   metric-windows-disk.ps1
#
# DESCRIPTION:
#   This plugin collects and outputs all Disk/HDD Statistic in a Graphite acceptable format.
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
#   Powershell.exe -NonInteractive -NoProfile -ExecutionPolicy Bypass -NoLogo -File C:\\etc\\sensu\\plugins\\metric-windows-disk.ps1
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

$driveArray=(Get-CimInstance -ClassName Win32_PerfFormattedData_PerfDisk_PhysicalDisk | Where Name -NotLike '_Total' |Select -ExpandProperty Name)

foreach ($drive in $driveArray) {
    $driveLetter = $drive -Replace '[^a-zA-Z]', ''
    $perfObject=(Get-CimInstance -ClassName Win32_PerfFormattedData_PerfDisk_PhysicalDisk -Filter "Name Like '$drive'")

    $value=($perfObject | Select -ExpandProperty AvgDiskBytesPerRead)
    Write-Host "$Path.disk.iostat.$diskname.read_bytes $value $Time"

    $value=($perfObject | Select -ExpandProperty AvgDiskBytesPerWrite)
    Write-Host "$Path.disk.iostat.$diskname.write_bytes $value $Time"

    $value=($perfObject | Select -ExpandProperty AvgDisksecPerRead)
    Write-Host "$Path.disk.iostat.$diskname.read_await $value $Time"

    $value=($perfObject | Select -ExpandProperty AvgDisksecPerWrite)
    Write-Host "$Path.disk.iostat.$diskname.write_await $value $Time"

    $value=($perfObject | Select -ExpandProperty CurrentDiskQueueLength)
    Write-Host "$Path.disk.iostat.$diskname.queue_length $value $Time"
}