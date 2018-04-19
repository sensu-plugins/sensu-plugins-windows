#
#   check-windows-http.ps1
#
# DESCRIPTION:
#   This plugin checks availability of link provided as param
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
#   Powershell.exe -NonInteractive -NoProfile -ExecutionPolicy Bypass -NoLogo -File C:\\etc\\sensu\\plugins\\check-windows-http.ps1 https://google.com
#
# NOTES:
#
# LICENSE:
#   Copyright 2016 sensu-plugins
#   Released under the same terms as Sensu (the MIT license); see LICENSE for details.
#
#Requires -Version 3.0
[CmdletBinding()]
Param(
  [Parameter(Mandatory=$True,Position=1)]
   [string]$CheckAddress
)

$ThisProcess = Get-Process -Id $pid
$ThisProcess.PriorityClass = "BelowNormal"

try {
  $Available = Invoke-WebRequest $CheckAddress -ErrorAction SilentlyContinue
}

catch {
  $errorhandler = $_.Exception.request
}

if (!$Available) {
  Write-Host CRITICAL: Could not connect  $CheckAddress!
  Exit 2 
}

if ($Available) {
   if ($Available.statuscode -eq 200) {
      Write-Host OK: $CheckAddress is available!
      Exit 0
   } else {
      Write-Host CRITICAL: URL $CheckAddress is not accessible!
      Exit 2
   }
}
