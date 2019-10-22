#
#   perfhelper.ps1
#
# DESCRIPTION:
#   This is file provides useful functions for powershell based metric checks
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
#   To use these functions dot source this file. 
#	Example: . (Join-Path $PSScriptRoot perfhelper.ps1)
#
# NOTES:
#
# LICENSE:
#   Copyright 2016 sensu-plugins
#   Released under the same terms as Sensu (the MIT license); see LICENSE for details.
#
#
# Taken from: http://www.powershellmagazine.com/2013/07/19/querying-performance-counters-from-powershell/
# THX!
#


function Get-PerformanceCounterByID
{
    param
    (
        [Parameter(Mandatory=$true)]
        $Name
    )

    $hashfile = (Join-Path $PSScriptRoot perfhash.hsh)

    if ([System.IO.File]::Exists($hashfile)) {
        
        $perfHash = Import-Clixml -Path $hashfile
    }
 
    if ($perfHash -eq $null)
    {
 
        $key = 'Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Perflib\009'
        $counters = (Get-ItemProperty -Path $key -Name Counter).Counter
        $perfHash = @{}
        $all = $counters.Count
 
        for($i = 0; $i -lt $all; $i+=2)
        {
           $perfHash.$($counters[$i+1]) = $counters[$i]
        }

        Export-Clixml -InputObject $perfHash -Path $hashfile

    }
 
   $perfHash.$Name
}

$signature = @'
[DllImport("pdh.dll", SetLastError = true, CharSet = CharSet.Unicode)]
static extern UInt32 PdhLookupPerfNameByIndex(string szMachineName, uint dwNameIndex, StringBuilder szNameBuffer, ref uint pcchNameBufferSize);
'@;

Function Get-PerformanceCounterLocalName
{
  param
  (
    [UInt32]
    $ID,
 
    $ComputerName = $env:COMPUTERNAME
  )
 
  $code = '[DllImport("pdh.dll", SetLastError=true, CharSet=CharSet.Unicode)] public static extern UInt32 PdhLookupPerfNameByIndex(string szMachineName, uint dwNameIndex, System.Text.StringBuilder szNameBuffer, ref uint pcchNameBufferSize);'
 
  $Buffer = New-Object System.Text.StringBuilder(1024)
  [UInt32]$BufferSize = $Buffer.Capacity
 
  $t = Add-Type -MemberDefinition $code -PassThru -Name PerfCounter -Namespace Utility
  $rv = $t::PdhLookupPerfNameByIndex($ComputerName, $id, $Buffer, [Ref]$BufferSize)
 
  if ($rv -eq 0)
  {
    $Buffer.ToString().Substring(0, $BufferSize-1)
  }
  else
  {
    Throw 'Get-PerformanceCounterLocalName : Unable to retrieve localized name. Check computer name and performance counter ID.'
  }
}

Function DateTimeToUnixTimestamp([datetime]$DateTime)
{
    $utcDate = $DateTime.ToUniversalTime()
    # Convert to a Unix time without any rounding
    [uint64]$UnixTime = [double]::Parse((Get-Date -Date $utcDate -UFormat %s))
    return [uint64]$UnixTime
}