#
#  check-focusedprocess.ps1
#
# DESCRIPTION:
#   This plugin checks the focused process.
#
#   It accepts the '-Process' parameter.
#   
# OUTPUT:
#   OK example:
#     FocusedProcess OK:
#       <name> is focused.
#
#  CRITICAL example:
#    FocusedProcess CRITICAL:
#      The following process is not focused:
#        - <name>
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
  # Process to check. If not the focused process, return CRITICAL (2) status. 
  [Parameter(
    Mandatory = $False
  )]
  [string]$Process,

  # Display help about this check.
  [switch]$Help
)

# Import template
$here = Split-Path -Parent $MyInvocation.MyCommand.Path
. "$here\check-multi-template.ps1"

# Override check options
$CheckOptions = @{
    'CheckName' = 'FocusedProcess'
    'MessageOK' = "$Process is focused."
    'MessageCritical' = 'The following process is not focused:'
    'MessageNoneSpecified' = 'No process specified.'
    'CheckMissing' = $False
    'Inverse' = $True
    'ScriptBlockMatchItems' = {
        Add-Type @"
using System;
using System.Runtime.InteropServices;
public class UserWindows {
    [DllImport("user32.dll")]
    public static extern IntPtr GetForegroundWindow();
}
"@
    
        try {            
            $ActiveHandle = [UserWindows]::GetForegroundWindow()            
            $Process = Get-Process |
                       Where-Object { $_.MainWindowHandle -eq $activeHandle } 
            $Process | 
            Select-Object -ExpandProperty ProcessName
            #Select-Object ProcessName,
            #              @{ N="AppTitle"; E= {($_.MainWindowTitle)} }            
        } catch {            
            Throw "Failed to get active Window details. More Info: $_"
        }
    }

    'CheckHelp' = @'
Checks the currently focussed process on a machine. This is useful for machines
such as digital signage that should always have a dedicated process displayed.

Arguments:
  -Process    The process name that should be focused.
  -Help       Show help

Example usage:
  powershell.exe -file check-focusedprocess.ps1 -process "chrome"

'@
}

if ((Format-ParamArray -Param $Process).Count -gt 1) {
    Throw 'Only accepts a single process'
}

# Run!
Invoke-Main -CriticalItems $Process