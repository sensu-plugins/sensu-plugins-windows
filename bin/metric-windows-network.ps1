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
    [string[]]$Interfaces,
    [switch]$UseFullyQualifiedHostname,
    [switch]$ListInterfaces
    )

$ThisProcess = Get-Process -Id $pid
$ThisProcess.PriorityClass = "BelowNormal"

. (Join-Path $PSScriptRoot perfhelper.ps1)

if ($UseFullyQualifiedHostname -eq $false) {
    $Hostname = ($env:computername).ToLower()
}else {
    $Hostname = [System.Net.Dns]::GetHostEntry([string]"localhost").HostName.toLower()
}

$perfCategoryID = Get-PerformanceCounterByID -Name 'Network Interface'
if ($perfCategoryID.Length -eq 0 ) {
  Write-Host "perfCategoryID: is Null"
  Exit 2
}
$localizedCategoryName = Get-PerformanceCounterLocalName -ID $perfCategoryID

for($i = 0; $i -lt $Interfaces.Count; $i+=1) {
    $tmp = $Interfaces[$i]
    $Interfaces[$i] = $tmp.Replace(" ","_")
}

if ($ListInterfaces -eq $true) {
  Write-Host "List of Available Interface Names"
  Write-Host "Full Name :: Underscore Modified Name"
  Write-Host "-------------------------------------"
}
foreach ($ObjNet in (Get-Counter -Counter "\$localizedCategoryName(*)\*").CounterSamples) 
{ 
  $instanceName=$ObjNet.InstanceName.ToString().Replace(" ","_")
  if ($ListInterfaces -eq $true) {
    $str = $ObjNet.InstanceName.ToString()
    Write-Host "$str :: $instanceName"
    Break
  }

  $include = $false
  if ($Interfaces.Count -eq 0) {
    $include = $true
  } else {
    if ($Interfaces.Contains($instanceName)) {
      $include = $true
    }
 }

 if ( $include -eq $true ) {
     $Measurement = ($ObjNet.Path).Trim("\\") -replace "\\","." -replace " ","_" -replace "[(]","." -replace "[)]","" -replace "[\{\}]","" -replace "[\[\]]",""

	 $Measurement = $Measurement.Remove(0,$Measurement.IndexOf("."))   
	 $Path = $Hostname+$Measurement

     $Path = $Path.Replace("/s","_per_second")
     $Path = $Path.Replace(":","")
     $Path = $Path.Replace(",","")
     $Path = $Path.Replace("ä","ae")
     $Path = $Path.Replace("ö","oe")
     $Path = $Path.Replace("ü","ue")
	 $Path = $Path.Replace("ß","ss")

     $Value = [System.Math]::Round(($ObjNet.CookedValue),0)
     $Time = DateTimeToUnixTimestamp -DateTime (Get-Date)

     Write-Host "$Path $Value $Time"

   }

}

