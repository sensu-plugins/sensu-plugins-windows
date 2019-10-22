#
#   metric-windows-disk-usage.ps1
#
# DESCRIPTION:
#   This plugin collects and outputs Disk Usage metrics in a Graphite acceptable format.
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
#   Powershell.exe -NonInteractive -NoProfile -ExecutionPolicy Bypass -NoLogo -File C:\\etc\\sensu\\plugins\\metric-windows-disk-usage.ps1
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

$AllDisks = Get-CimInstance -ClassName Win32_LogicalDisk -Filter "DriveType = 3" | Where-Object { $_.DeviceID -notmatch "[ab]:"}

foreach ($ObjDisk in $AllDisks) 
{
  $DeviceId = $ObjDisk.DeviceID -replace ":",""

  $UsedSpace = [System.Math]::Round((($ObjDisk.Size-$ObjDisk.Freespace)/1MB),2)
  $AvailableSpace = [System.Math]::Round(($ObjDisk.Freespace/1MB),2)
  $UsedPercentage = [System.Math]::Round(((($ObjDisk.Size-$ObjDisk.Freespace)/$ObjDisk.Size)*100),2)

  $Time = DateTimeToUnixTimestamp -DateTime (Get-Date)

  Write-Host "$Path.disk.usage.$DeviceId.UsedMB $UsedSpace $Time"
  Write-Host "$Path.disk.usage.$DeviceId.FreeMB $AvailableSpace $Time"
  Write-Host "$Path.disk.usage.$DeviceId.UsedPercentage $UsedPercentage $Time"
}
