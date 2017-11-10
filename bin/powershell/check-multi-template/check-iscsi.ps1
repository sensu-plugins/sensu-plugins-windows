#
#  check-iscsi.ps1
#
# DESCRIPTION:
#   This plugin checks that the specified iSCSI sessions are connected.
#
#   It accepts the '-CriticalIQNs and '-ImportantIQNs' parameters to provide
#   different status level outputs and also checks if the items passed are 
#   missing completely. Please see the '-Help' parameter, under the 'Sensu 
#   check token substitution' header for more info on some extra parsing 
#   features.
#   
#   It is built atop check-multi-template.ps1 as an example, and can be easily 
#   adapted to check other things.
#
# OUTPUT:
#   OK example:
#     CheckIscsi OK:
#       All iSCSI sessions are connected.
#
#  WARN example:
#    CheckIscsi WARN:
#      The following important sessions are not connected:
#        - iqn.2001-05.com.equallogic:4-42a846-3d3bb3c30-9140000001255ddf-vol01
#
#  CRITICAL example:
#    CheckIscsi CRITICAL:
#      The following critical sessions are not connected:
#        - iqn.2001-05.com.equallogic:4-42a846-3d3bb3c30-9140000001255ddf-vol01
#
#    CheckIscsi CRITICAL:
#      The following critical sessions are not connected:
#        - iqn.2001-05.com.equallogic:4-42a846-3d3bb3c30-9140000001255ddf-vol01
#      The following important sessions are not connected:
#        - iqn.2001-05.com.equallogic:4-42a846-3d3bb3c30-9140000001255ddf-vol02
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
  # Target IQNs to check. If any are not connected, they will return a
  # CRITICAL (2) status. 
  [Parameter(
    Mandatory = $False
  )]
  [string]$CriticalIQNs,
  
  # Target IQNs to check. If any are not connected, they will return a
  # WARNING (1) status. 
  [Parameter(
    Mandatory = $False
  )]
  [string]$ImportantIQNs,

  # Display help about this check.
  [switch]$Help
)

# Import template
$here = Split-Path -Parent $MyInvocation.MyCommand.Path
. "$here\check-multi-template.ps1"

# Override check options
$CheckOptions = @{
    'CheckName' = 'CheckIscsi'
    'MessageOK' = 'All iSCSI sessions are connected.'
    'MessageImportant' = 'The following important sessions are not connected:'
    'MessageCritical' = 'The following critical sessions are not connected:'
    'MessageMissing' = 'The following sessions are missing:'
    'MessageNoneSpecified' = 'No IQNs specified.'
    'MissingState' = 2
    'Inverse' = $True

    'ScriptBlockBaseItems' = {
        Get-IscsiSession |
        Select-Object -ExpandProperty TargetNodeAddress
    }

    'ScriptBlockMatchItems' = {
        Get-IscsiSession |
        Select-Object -ExpandProperty TargetNodeAddress
    }

    'CheckHelp' = @'
Checks whether any specified iSCSI sessions are not connected.

Arguments:
  -CriticalIQNs    A string of comma-separated iSCSI IQNs
  -ImportantIQNs   A string of comma-separated iSCSI IQNs
  -Help            Show help

Example usage:
  powershell.exe -file check-iscsi.ps1 -criticaliqns "iqn..." -warningiqns "iqn..."

'@
}

# Run!
Invoke-Main -CriticalItems $CriticalIQNs -ImportantItems $ImportantIQNs