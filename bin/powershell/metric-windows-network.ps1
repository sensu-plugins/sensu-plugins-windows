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
$ThisProcess = Get-Process -Id $pid
$ThisProcess.PriorityClass = "BelowNormal"

$perfCategoryID = Get-PerformanceCounterByID -Name 'Network Interface'
$localizedCategoryName = Get-PerformanceCounterLocalName -ID $perfCategoryID

foreach ($ObjNet in (Get-Counter -Counter "\$localizedCategoryName(*)\*").CounterSamples) 
{ 
  $Path = ($ObjNet.Path).Trim("\\") -replace "\\","." -replace " ","_" -replace "[(]","." -replace "[)]","" -replace "[\{\}]","" -replace "[\[\]]",""
  $Value = [System.Math]::Round(($ObjNet.CookedValue),0)
  $Time = [int][double]::Parse((Get-Date -UFormat %s))

  Write-Host "$Path $Value $Time"
}
