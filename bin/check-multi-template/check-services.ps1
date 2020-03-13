#
#  check-services.ps1
#
# DESCRIPTION:
#   This plugin checks that the specified network adapters are up.
#
#   It accepts the '-CriticalServices' and '-ImportantServices' parameters to 
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
#     CheckService CRITICAL:
#       The following services are missing:
#         - salt-minion
#
#   OK example: 
#     CheckService OK:
#       All services are running.
#
#   WARN example:
#     CheckService WARN:
#       The following important services are not running:
#         - salt-minion
#
#   CRITICAL example:
#     CheckService CRITICAL:
#       The following critical services are not running:
#         - dns
#       The following important services are not running:
#         - salt-minion
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
  # Services to check. If any are not running, they will return a
  # CRITICAL (2) status. 
  [Parameter(
    Mandatory = $False
  )]
  [string]$CriticalServices,
  
  # Services to check. If any are not running, they will return a
  # WARNING (1) status. 
  [Parameter(
    Mandatory = $False
  )]
  [string]$ImportantServices,

  # Display help about this check.
  [switch]$Help
)

# Import template
$here = Split-Path -Parent $MyInvocation.MyCommand.Path
. "$here\check-multi-template.ps1"

# Override check options
$CheckOptions = @{
    'CheckName' = 'CheckService'
    'MessageOK' = 'All services are running.'
    'MessageImportant' = 'The following important services are not running:'
    'MessageCritical' = 'The following critical services are not running:'
    'MessageMissing' = 'The following services are missing:'
    'MessageNoneSpecified' = 'No services specified.'
    'MissingState' = 2
    'CheckMissing' = $True

    'ScriptBlockBaseItems' = {
        Get-Service |
        Select-Object -ExpandProperty Name
    }

    'ScriptBlockMatchItems' = {
        Get-Service |
        Where-Object { $_.Status -ne 'Running' } |
        Select-Object -ExpandProperty Name
    }

    'CheckHelp' = @'
Checks whether any specified services are not running.

Arguments:
  -CriticalServices    A string of comma-separated services
  -ImportantServices   A string of comma-separated services
  -Help                Show help

Example usage:
  powershell.exe -file check-adapters.ps1 -CriticalServices "CLUSTER NETWORK" -warningadapters"MONITORING NETWORK"

'@
}

# Run!
Invoke-Main -CriticalItems $CriticalServices -ImportantItems $ImportantServices