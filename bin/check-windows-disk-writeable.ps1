#
#   check-windows-disk-writeable.ps1
#
# DESCRIPTION:
#   This plugin collects the mounted logical disks and tests they are writeable.
#
# OUTPUT:
#   plain text
#
# PLATFORMS:
#   Windows
#
# DEPENDENCIES:
#   PowerShell 2.0 or above
#
# USAGE:
#   Powershell.exe -NonInteractive -NoProfile -ExecutionPolicy Bypass -NoLogo -File C:\\etc\\sensu\\plugins\\check-windows-disk-writeable.ps1
#   Powershell.exe -NonInteractive -NoProfile -ExecutionPolicy Bypass -NoLogo -File C:\\etc\\sensu\\plugins\\check-windows-disk-writeable.ps1 -DriveType "3,5" -Ignore "A,B" -TestFile '\test.txt'
#
# NOTES:
#
# LICENSE:
#   Copyright 2017 sensu-plugins
#   Released under the same terms as Sensu (the MIT license); see LICENSE for details.
#

#Requires -Version 3.0

[CmdletBinding()]
Param(
  # DriveType, see available options at https://msdn.microsoft.com/en-us/library/windows/desktop/aa364939(v=vs.85).aspx
  # Specify multiple values as a comma separated string, e.g. "3,5"
  [Parameter(Mandatory=$False)]
  [string]$DriveType = "3",

  # Disk letters to ignore
  # Specify multiple values as a comma separated string, e.g. "C,D"
  [Parameter(Mandatory=$False)]
  [string]$Ignore = "None",

  # Test file to create on each disk to test it is writeable
  [Parameter(Mandatory=$False)]
  [string]$TestFile = "\testfile.txt"
)

$ThisProcess = Get-Process -Id $pid
$ThisProcess.PriorityClass = "BelowNormal"

$crit = 0
$critDisks = ""

$AllDisks = @()
Foreach ($DT in $($DriveType -split(','))) {
  Get-CimInstance -ClassName Win32_LogicalDisk -Filter "DriveType = ${DT}" | Where-Object { $_.DeviceID -notmatch "[$($Ignore.Replace(',',''))]:"} | %{ $AllDisks += $_ }
}

if ($AllDisks.count -eq 0) {
  Write-Host "CheckDiskWriteable UNKNOWN: No logical disks of DriveType $($DriveType -Replace(',', ' or ')) found"
  exit 3
}

foreach ($ObjDisk in $AllDisks) {

  $ID = $ObjDisk.DeviceID
  $TestPath = $ID + $TestFile

  $Writeable = $True
  Try {
    [io.file]::OpenWrite($TestPath).close()
    Remove-Item $TestPath
  }
  Catch {
    Write-Verbose "Unable to write to output file $TestPath"
    $Writeable = $False
  }

  if ($Writeable -eq $False) {
    $crit += 1
    $critDisks += "$ID is not writeable `n"
  }
}

if ($crit -ne 0) {
  Write-Host "CheckDiskWriteable CRITICAL: $crit disks in critical state: `n$critDisks"
  exit 2
}

Write-Host "CheckDiskWriteable OK: All disks are writeable."
Exit 0
