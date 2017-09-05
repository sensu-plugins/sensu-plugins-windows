#
#   metric-windows-network.ps1
#
# DESCRIPTION:
#   This plugin collects and outputs all Network Adapater Statistic in a Graphite acceptable format.
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
#   Powershell.exe -NonInteractive -NoProfile -ExecutionPolicy Bypass -NoLogo -File C:\\etc\\sensu\\plugins\\metric-windows-network.ps1
#
# NOTES:
#
# LICENSE:
#   Copyright 2016 sensu-plugins
#   Released under the same terms as Sensu (the MIT license); see LICENSE for details.
#

param(
    [string[]]$Interfaces
    )

$ThisProcess = Get-Process -Id $pid
$ThisProcess.PriorityClass = "BelowNormal"

. (Join-Path $PSScriptRoot perfhelper.ps1)

$perfCategoryID = Get-PerformanceCounterByID -Name 'Network Interface'
$localizedCategoryName = Get-PerformanceCounterLocalName -ID $perfCategoryID

foreach ($ObjNet in (Get-Counter -Counter "\$localizedCategoryName(*)\*").CounterSamples) 
{ 
  
  if ($Interfaces.Contains($ObjNet.InstanceName)) {

     $Path = ($ObjNet.Path).Trim("\\") -replace "\\","." -replace " ","_" -replace "[(]","." -replace "[)]","" -replace "[\{\}]","" -replace "[\[\]]",""
     $Path = $Path.Replace("/s","_per_second")
     $Path = $Path.Replace(":","")
     $Path = $Path.Replace(",","")
     $Path = $Path.Replace("ä","ae")
     $Path = $Path.Replace("ö","oe")
     $Path = $Path.Replace("ü","ue")
     $Value = [System.Math]::Round(($ObjNet.CookedValue),0)
     $Time = DateTimeToUnixTimestamp -DateTime (Get-Date)

     Write-Host "$Path $Value $Time"

   }

}