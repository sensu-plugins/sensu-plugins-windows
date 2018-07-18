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

$counters =  New-Object System.Collections.ArrayList
$instances =  @{}

$ThisProcess = Get-Process -Id $pid
$ThisProcess.PriorityClass = "BelowNormal"

. (Join-Path $PSScriptRoot perfhelper.ps1)

if ($UseFullyQualifiedHostname -eq $false) {
    $Path = ($env:computername).ToLower()
}else {
    $Path = [System.Net.Dns]::GetHostEntry([string]"localhost").HostName.toLower()
}

$perfCategoryID = Get-PerformanceCounterByID -Name 'PhysicalDisk'
$localizedCategoryName = Get-PerformanceCounterLocalName -ID $perfCategoryID

[void]$counters.Add('Avg. Disk Bytes/Read')
[void]$counters.Add('Avg. Disk Bytes/Write')
[void]$counters.Add('Avg. Disk sec/Read')
[void]$counters.Add('Avg. Disk sec/Write')
[void]$counters.Add('Current Disk Queue Length')

foreach ($ObjDisk in (Get-Counter -Counter "\$localizedCategoryName(*)\*").CounterSamples) {

   if ($instances.ContainsKey($ObjDisk.InstanceName) -eq $false) {

        if ($ObjDisk.InstanceName.ToLower() -ne '_total') {
            $disk = $ObjDisk.InstanceName
            $disk = $disk.Remove(0,1)
            $disk = $disk.Replace(":","")
            $disk = $disk.Trim()
            $instances.Add($ObjDisk.InstanceName,$disk.toUpper())
        }

   }

}

foreach ($diskkey in $instances.Keys) {

    $diskname = $instances.$diskkey

    foreach ($counter in $counters) {

        $perfCounterID = Get-PerformanceCounterByID -Name $counter
        $localizedCounterName = Get-PerformanceCounterLocalName -ID $perfCounterID
        $value = [System.Math]::Round((Get-Counter "\$localizedCategoryName($diskkey)\$localizedCounterName" -SampleInterval 1 -MaxSamples 1).CounterSamples.CookedValue)

        $Time = DateTimeToUnixTimestamp -DateTime (Get-Date)

        if ($counter -eq 'Avg. Disk Bytes/Read') { Write-Host "$Path.disk.iostat.$diskname.read_bytes $value $Time" }
        if ($counter -eq 'Avg. Disk Bytes/Write') { Write-Host "$Path.disk.iostat.$diskname.write_bytes $value $Time" }
        if ($counter -eq 'Avg. Disk sec/Read') { Write-Host "$Path.disk.iostat.$diskname.read_await $value $Time" }
        if ($counter -eq 'Avg. Disk sec/Write') { Write-Host "$Path.disk.iostat.$diskname.write_await $value $Time" }
        if ($counter -eq 'Current Disk Queue Length') { Write-Host "$Path.disk.iostat.$diskname.queue_length $value $Time" }

    }

}
