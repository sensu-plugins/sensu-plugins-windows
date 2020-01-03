#
#  check-adapters.ps1
#
# DESCRIPTION:
#   This plugin checks that the specified network adapters are up.
#
#   It accepts the '-CriticalAdapters' and '-ImportantAdapters' parameters to 
#   provide different status level outputs and also checks if the items passed 
#   are missing completely. Please see the '-Help' parameter, under the 'Sensu 
#   check token substitution' header for more info on some extra parsing 
#   features.
#   
#   It is built atop check-multi-template.ps1 as an example, and can be easily
#   adapted to check other things.
#
# OUTPUT:
#   Missing example:
#     CheckNetworkAdapter CRITICAL:
#       The following adapters are missing:
#         - Ethernet
#
#   OK example: 
#     CheckNetworkAdapter OK:
#       All interfaces are up.
#
#   WARN example:
#     CheckNetworkAdapter WARN:
#       The following important adapters are down:
#         - OOB MANAGEMENT
#
#   CRITICAL example:
#     CheckNetworkAdapter CRITICAL:
#       The following critical adapters are down:
#         - CLUSTER HEARTBEAT
#       The following important adapters are down:
#         - OOB MANAGEMENT
#
# PLATFORMS:
#   Windows
#
# DEPENDENCIES:
#
# USAGE:
#   Please run this check with the '-help' parameter for more info.
#
# NOTES:
#
# LICENSE:
#   Copyright 2016 James Booth <james@absolutejam.co.uk>
#   Released under the same terms as Sensu (the MIT license); see LICENSE for 
#   details.
#


[CmdletBinding()]
Param(
  # Network adapters to check. If any are not 'up', they will return a
  # CRITICAL (2) status. 
  [Parameter(
    Mandatory = $False
  )]
  [string]$CriticalAdapters,
  
  # Network adapters to check. If any are not 'up', they will return a
  # WARNING (1) status. 
  [Parameter(
    Mandatory = $False
  )]
  [string]$ImportantAdapters,

  # Display help about this check.
  [switch]$Help
)

# Import template
$here = Split-Path -Parent $MyInvocation.MyCommand.Path
. "$here\check-multi-template.ps1"

# Override check options
$CheckOptions = @{
    'CheckName' = 'CheckNetworkAdapter'
    'MessageOK' = 'All interfaces are up.'
    'MessageImportant' = 'The following important adapters are down:'
    'MessageCritical' = 'The following critical adapters are down:'
    'MessageMissing' = 'The following adapters are missing:'
    'MessageNoneSpecified' = 'No adapters specified.'
    'MissingState' = 2

    'ScriptBlockBaseItems' = {
        Get-NetAdapter |
        Select-Object -ExpandProperty Name
    }

    'ScriptBlockMatchItems' = {
        Get-NetAdapter |
        Where-Object { $_.Status -ne 'Up' } |
        Select-Object -ExpandProperty Name
    }

    'CheckHelp' = @'
Checks whether any specified network adapters are not 'up'.

Arguments:
  -CriticalAdapters    A string of comma-separated network adapters
  -ImportantAdapters   A string of comma-separated network adapters
  -Help                Show help

Example usage:
  powershell.exe -file check-adapters.ps1 -criticaladapters "CLUSTER NETWORK" -warningadapters"MONITORING NETWORK"

'@
}

# Run!
Invoke-Main -CriticalItems $CriticalAdapters -ImportantItems $ImportantAdapters