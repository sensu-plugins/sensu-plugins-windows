#
#   check-windows-service.ps1
#
# DESCRIPTION:
#   This plugin checks whether a User-inputted Windows service is running or not.
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
#   Powershell.exe -NonInteractive -NoProfile -ExecutionPolicy Bypass -NoLogo -File C:\\etc\\sensu\\plugins\\check-windows-service.ps1
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
   [string]$ServiceName
)

# Function to help the exitcode be seen by Sensu
function ExitWithCode
{
    param
    (
        $exitcode
    )

    $host.SetShouldExit($exitcode)
    exit
}
$ThisProcess = Get-Process -Id $pid
$ThisProcess.PriorityClass = "BelowNormal"

$Exists = Get-Service $ServiceName -ErrorAction SilentlyContinue

If ($Exists) {
  If (($Exists).Status -eq "Running") {
    Write-Host OK: $ServiceName Running.
    ExitWithCode 0 }

  If (($Exists).Status -eq "Stopped") {
    Write-Host CRITICAL: $ServiceName Stopped.
    ExitWithCode 2 }
}

If (!$Exists) {
  Write-Host CRITICAL: $ServiceName not found!
  ExitWithCode 2 }
