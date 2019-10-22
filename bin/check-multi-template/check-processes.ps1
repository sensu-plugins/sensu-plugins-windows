#
#  check-processes.ps1
#
# DESCRIPTION:
#   This plugin checks that the specified processes are running.
#
#   It accepts the '-CriticalProcesses' and '-ImportantProcesses' parameters to 
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
#     CheckProcesses CRITICAL:
#       The following processes are not running:
#         - chrome
#
#   OK example: 
#     CheckProcesses OK:
#       All processes are running.
#
#   WARN example:
#     CheckProcesses WARN:
#       The following processes are not running:
#         - firefox
#
#   CRITICAL example:
#     CheckProcesses CRITICAL:
#       The following critical processes are not running:
#         - chrome
#       The following critical processes are not running:
#         - firefox
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
  # Processes to check. If any are not running, they will return a
  # CRITICAL (2) status. 
  [Parameter(
    Mandatory = $False
  )]
  [string]$CriticalProcesses,
  
  # Processes to check. If any are not running, they will return a
  # WARNING (1) status. 
  [Parameter(
    Mandatory = $False
  )]
  [string]$ImportantProcesses,

  # Display help about this check.
  [switch]$Help
)

# Import template
$here = Split-Path -Parent $MyInvocation.MyCommand.Path
. "$here\check-multi-template.ps1"

# Override check options
$CheckOptions = @{
    'CheckName' = 'CheckProcesses'
    'MessageOK' = 'All processes are up.'
    'MessageImportant' = 'The following important processes are not running:'
    'MessageCritical' = 'The following critical processes are not running:'
    'MessageNoneSpecified' = 'No processes specified.'
    'Inverse' = $True
    'MissingState' = 2

    'ScriptBlockMatchItems' = {
      Get-Process |
      Select-Object -ExpandProperty ProcessName
    }

    'CheckHelp' = @'
Checks whether any specified processes are not running.

Arguments:
  -CriticalProcesses    A string of comma-separated processes
  -ImportantProcesses   A string of comma-separated processes
  -Help                 Show help

Example usage:
  powershell.exe -file check-processes.ps1 -criticalprocesses "chrome,notepad" -warningprocesses "firefox"

'@
}

# Run!
Invoke-Main -CriticalItems $CriticalProcesses -ImportantItems $ImportantProcesses