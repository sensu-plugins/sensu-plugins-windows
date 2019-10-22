#
#  check-muilti-template.ps1
#
# DESCRIPTION:
#   This is a teplate which should be imported and adapted with the use of a
#   $CheckOptions object.
#
#   By default, it will check the state of Windows services, just to provide
#   an example. Please also see the example 'check-adapters.ps1' for more
#   info on how to build on this template.
#
#   Please see the '-Help' parameter, under the 'Sensu check token 
#   substitution' header for more info on some extra parsing features.
#
# OUTPUT:
#   plain text
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
#   Released under the same terms as Sensu (the MIT license); see LICENSE for details.
#


#REGION Configurables

[CmdletBinding()]
Param(
  # Items to check. If any of these items are in a 'failed' state, the check
  # will return a CRITICAL (2) status. 
  # Please supply -Help for more information.
  [Parameter(
    Mandatory = $False
  )]
  [array]$CriticalItems,
  
  # Items to check. If any of these items are in a 'failed' state, the check
  # will return a WARNING (1) status. 
  # Please supply -Help for more information.
  [Parameter(
    Mandatory = $False
  )]
  [array]$ImportantItems,

  # Display help about this check.
  [switch]$Help = $Help
    # This is so wrapper scripts can pass through '-help'

)

# Default options. Overridee after importing if required.
$CheckOptions = @{
    # Example output using below values:
    #   CheckName CRITICAL: The following items are in a failed state:
    #     - ItemOne
    #     - ItemTwo

    # The name of the check
    'CheckName' = 'CheckItem'
    # The message to display in event of an OK state
    'MessageOK' = 'All items are in an OK state.'
    # The message to display in event of a WARNING state
    'MessageImportant' = 'The following important items are in a failed state:'
    # The message to display in event of a CRITICAL state
    'MessageCritical' = 'The following critical items are in a failed state:'
    # The message to display in event of missing items
    'MessageMissing' = 'The following items are missing:'
    # The message to display if no items are specified
    'MessageNoneSpecified' = 'No items specified.'
    # Change this to $True if you want to check for items that are missing
    # from FailedItems
    'Inverse' = $False
    # Check if any items are missing
    'CheckMissing' = $True
    # State of check in the event of missing items 
    # (1 OK 2 WARNING 3 CRITICAL)
    'MissingState' = 2

    # NOTE: The following scriptblocks must return comparable data
    #       eg. an array of strings
    # ScriptBlock to get ALL items
    'ScriptBlockBaseItems' = {
        Get-Service |
        Select-Object -ExpandProperty Name
    }
    # ScriptBlock to get FAILED items
    'ScriptBlockMatchItems' = {
        Get-Service |
        Where-Object { $_.Status -ne 'Running' } |
        Select-Object -ExpandProperty Name
    }
    # Help message for this check
    'CheckHelp' = @'
Checks whether any specified items are in a failed state.

Arguments:
  -CriticalItems    A string of comma-separated items
  -ImportantItems   A string of comma-separated items
  -Help             Show help

Example usage:
  powershell.exe -file check-multi-template.ps1 -criticalitems "item1,item2" -warningitems "item3,item4"

'@
}

#ENDREGION Configurables


#REGION Functions

Function Format-ParamArray {
    <#
    .SYNOPSIS
        Convert an array of strings that contain comma-separated values into
        a single array of all the values. Also removes instances of 'None'.
    .EXAMPLE
        Add-OutputEntry -Status 2 -Items 'alpha','bravo'
    #>
    [CmdletBinding()]
    Param(
        # Array of arrays or strings to be flattened
        [Parameter(
            Mandatory = $False
        )]
        [string[]]$Param = @()
    )

    # Convert a single string into an array with a single value
    if ($Param -is [string]) {
        $Return = @($Param)
        return ,$Return
    }

    # Flatten the (potential) array into a string
    $Param = $Param -Join ','
    # Strip any instances of 'None'
    $Param = $Param -Replace 'None[,]?',''
    # Replace multiple consecutive commas with a single comma
    $Param = $Param -Replace '[,]{2,}',','
    # If the last character is a comma, remove it
    if ($Param[-1] -eq ',') {
        $Param = $Param.substring(0, $Param.Length-1)
    }
    # Split into an array
    [array]$Param = $Param -split ','

    return ,$Param
}

Function Write-ExitState {
    <#
    .SYNOPSIS
        Exit script with supplied exit code
    .PARAMETER ExitState
        The exit code/state of the check (0 OK, 1 WARNING, 2 CRITICAL)
    #>
    [CmdletBinding()]
    Param(
        [Parameter(
            Mandatory = $False
        )]
        [ValidateSet(0, 1, 2)] 
        [int]$ExitState = 0
    )

    Exit $ExitState
}

Function Add-OutputEntry {
    <#
    .SYNOPSIS
        Append check output to 'Output' array.
    .DESCRIPTION
        Allows multiple levels of check results to be included in a check's
        output by adding them all to a single 'Output' array and joining them
        upon submitting check result.
    .PARAMETER State
        The state of the check (0 OK, 1 WARNING, 2 CRITICAL)
    .PARAMETER Items
        Items to format into a bullet list that will be included in the check
        output, eg. a list of failed services that need attention.
    .PARAMETER Message
        Override the default message if required.
    .EXAMPLE
        Add-OutputEntry -Status 2 -Items 'alpha','bravo'
    #>
    [CmdletBinding()]
    Param(
        # The check state (0, 1, 2)
        [Parameter(
            Mandatory = $False
        )]
        [ValidateSet(0, 1, 2)] 
        [int]$State = 0,

        # Items to be enumerated in the check output.
        [Parameter(
            Mandatory = $False
        )]
        [array]$Items,

        # Supply a custom message.
        [Parameter(
            Mandatory = $False
        )]
        [string]$Message
    )

    $OutputEntry = New-Object PSObject -Property @{
        'State' = $State
        'Items' = $Items
        'Message' = $Message
    }
    $Output.Add($OutputEntry) | Out-Null

}

Function Test-NullParameters {
    <#
    .SYNOPSIS
        Exit with OK state if no parameters are passed to script.

    .PARAMETER Parameters
        Check that each item in the array isn#t an empty string.        
    #>
    [CmdletBinding()]
    Param(
        [array]$Parameters
    )

    # Check if any of the parameters (eg. CriticalItems) is empty
    $ParamCount = 0
    ForEach ($Parameter in $Parameters) {
        $ParamCount += $Parameter | 
                       Where-Object { $_ -ne '' } | 
                       Measure-Object | 
                       Select-Object -ExpandProperty Count
    }

    if ($ParamCount -eq 0) {
        Add-OutputEntry -State 0 -Message $CheckOptions.MessageNoneSpecified
        Write-CheckResult
    }
    
}

Function Compare-CheckItems {
    <#
    .SYNOPSIS
        Compares an 'BaseItems' array against an array of items that 
        we want to check the status of.
    
    .DESCRIPTION
        Compares a 'CompareItems' array against a 'BaseItems' array,
        returning either those items that are missing from BaseItems
        (-Missing flag), items that are present in both arrays.

        This lets us compare a list of critical services we want
        to ensure are running against an array of failed services,
        or compare a list of users we want to ensure are absent from
        the system against all users on the system.

    .PARAMETER BaseItems
        An arrayo of all items in a specific state, such as all services 
        available or all network adapters that are disconnected.
    
    .PARAMETER CompareItems
        An array of items that we want to explicitly check against the
        BaseItems array.

    .PARAMETER Missing
        Supply this parameter if you only want to return items that have
        been supplied but are missing from the BaseItems array (Essentially
        reverses the effect of the function).
    
    .EXAMPLE
        $CriticalServices = 'dhcp','dnscache'
        $AllServices = Get-Services | Select-Object -ExpandProperty Name
        Compare-CheckItems -BaseItems $AllServices -CompareItems $CriticalServices
    
    #>
    [CmdletBinding()]
    Param(
        [array]$BaseItems,
        [array]$CompareItems,
        [switch]$Missing
    )

    # If an array of arrays was passed, extract all values. Otherwise just 
    # use values from array.
    $MergedCompareItems = New-Object -TypeName System.Collections.ArrayList
    ForEach ($Item in $CompareItems |
             Where-Object { $_ -ne '' }) {
        if ($Item -is [array]) {
            ForEach ($ArrayItem in $Item |
                     Where-Object { $_ -ne '' }) {
                $MergedCompareItems.Add($ArrayItem) | Out-Null
            }
        } else {
            $MergedCompareItems.Add($Item) | Out-Null
        }
    }

    if ($Missing) {
        $ReturnItems = Compare-Object -ReferenceObject $MergedCompareItems `
                                      -DifferenceObject $BaseItems |
                       Where-Object { $_.SideIndicator -eq '<=' } |
                       Select-Object -ExpandProperty InputObject


    } else {
        $ReturnItems = Compare-Object -ReferenceObject $MergedCompareItems `
                                      -DifferenceObject $BaseItems `
                                      -ExcludeDifferent `
                                      -IncludeEqual |
                       Where-Object { $_.SideIndicator -eq '==' } |
                       Select-Object -ExpandProperty InputObject
    }

    # This hackery forces Powershell to return an array and stops it mangling
    # it into $Null or a string
    if ($ReturnItems -eq $Null) {
        $ReturnItems = ,@()
        Return $ReturnItems
    } else {
        return ,$ReturnItems
    }
}

Function Get-CheckStatus {
    <#
    .SYNOPSIS
        Returns a string containing the check status based on numerical state/
    #>
    [CmdletBinding()]
    Param(
        [array]$State
    )

    switch ($State) {
        0 {
            return New-Object PSObject -Property @{
                'Status' = 'OK:'
                'MessageBody' = $CheckOptions.MessageOK
            }
        }

        1 {
            return New-Object PSObject -Property @{
                'Status' = 'WARN:'
                'MessageBody' = $CheckOptions.MessageImportant
            }
        }

        2 {
            return New-Object PSObject -Property @{
                'Status' = 'CRITICAL:'
                'MessageBody' = $CheckOptions.MessageCritical
            }
        }
    }
}

Function Write-CheckResult() {
    <#
    .SYNOPSIS
        Return the frmatted check result based on $Output
    #>
    
    # Get the highest 'state' value and use that as the total check state
    $FinalState = $Output | Sort-Object -Property state -Descending | 
                  Select-Object -First 1 |
                  Select-Object -ExpandProperty 'State'

    $FinalStatus = Get-CheckStatus -State $FinalState | 
                   Select-Object -ExpandProperty 'Status'

    # Compile the final output
    $CheckMessage = New-Object -TypeName System.Collections.ArrayList
    $CheckMessage.Add(
        ('{0} {1}' -f $CheckOptions.CheckName,$FinalStatus)
    ) | Out-Null

    ForEach ($State in $Output |
                       Group-Object -Property State | 
                       Sort-Object -Property State -Descending) {

        ForEach ($Entry in $State.Group) {
            $CheckState = Get-CheckStatus -State $Entry.State

            if ($Entry.Message) { 
                $MessageBody = $Entry.Message
            } else {
                $MessageBody = $CheckState.MessageBody
            }

            if ($Entry.Items) {
                $Bullet = "`r`n    -"
                $ItemsInformation = "$Bullet {1}" -f $Bullet,($Entry.Items -join "$Bullet ")
            } else {
                $ItemsInformation = ''
            }

            #$Entry | gm

            # Format message to add
            $Message = "  {0}{1}" -f $MessageBody,$ItemsInformation

            $CheckMessage.Add($Message) | Out-Null
        }
    }

    Write-Output ($CheckMessage -join "`r`n")
    Write-ExitState -ExitState $FinalState
}

Function Write-Help() {
    <#
    .SYNOPSIS
        Exit, showing help text.
    #>
    Write-Output ("{0}`r`n{1}" -f $CheckOptions.CheckHelp, $CheckMultiHelp)
    Write-ExitState -ExitState 0
}

# This is standard across all checks using this template.
$CheckMultiHelp = @'
Sensu check token substitution:
  Because this check is designed to make full use of Sensu's check token 
  substitution (https://sensuapp.org/docs/latest/reference/checks.html#check-token-substitution)
  feature, some special considerations have been taken for how the arguments are parsed.

  The main parameters support a list of of comma-separated strings.
    eg. -CriticalItems 'value1','value2'
  They also accepts accept a single string with comma-separated values.
    eg. -param1 'value1,value2'
  ...or you can mix & match the two and all of the values will be merged.
    eg. -param1 'value1','value2,value3'
  Additionally, any use of the word 'None' will be ignored.
    eg. -param1 'value1','None,value2','None'

  This is because Sensu's client attribute substitution tokens only work with 
  flat strings, but by supporting both of the above methods, it allows the use
  of multiple values within a single check/client attribute AND multiple
  different client/check attributes to be used. Additionally, because 'None'
  is ignored, it allows the user to provide a default value in the check 
  token substitution, as not to throw an error if the value is missing.

Token substitution example:
  Check attribute 'check_attr'   = "alpha,bravo"
  Client attribute 'client_attr' = "charlie,delta"

    powershell.exe -File check.ps1 -param1 ":::check_attr|None:::",":::missing_attr|None:::",":::client_attr|None:::"
    
  Which evaluates to:

    powershell.exe -File check.ps1 -param "alpha,bravo","None","charlie,delta"

  The script then strips any instances of 'None' and processes the 
  comma-separated string as single flat array.
'@

#
# MAIN FUNCTION
#
Function Invoke-Main {
    <#
    .SYNOPSIS
        The main process. Run automatically when running the script, or when
        called if script is imported.

    .PARAMETER CriticalItems
        Variable to pass through to CriticalItems

    .PARAMETER ImportantItems
        Variable to pass through to ImportantItems
    #>
    [CmdletBinding()]
    Param(
        [Parameter(
            Mandatory = $False
          )]
        [array]$CriticalItems = @(),

        [Parameter(
            Mandatory = $False
          )]
        [array]$ImportantItems = @()
    )
    # If -Help is passed, show help and exit
    if ($Help) {
        Write-Help
    }

    # Setup
    $Output = New-Object -TypeName System.Collections.ArrayList

    # Merge the cli parameters into a single string
    $CriticalItemList = Format-ParamArray -Param $CriticalItems
    $ImportantItemList = Format-ParamArray -Param $ImportantItems

    # Exit if no/null parameters specified
    Test-NullParameters -Parameters $CriticalItemList,$ImportantItemList

    # Evaluate the scriptblocks so we can compare items passed into the script
    # vs. running state.
    if ($CheckOptions.CheckMissing -ne $False -and
        $CheckOptions.Inverse -ne $True) {
        $BaseItems = & $CheckOptions.ScriptblockBaseItems
    }
    $MatchItems = & $CheckOptions.ScriptBlockMatchItems
    if ($MatchItems.Count -eq 0) { $MatchItems = ,@() }

    # Check that all of the items specified are present before checking their
    # status
    if ($CheckOptions.CheckMissing -ne $False -and
        $CheckOptions.Inverse -ne $True) {
        $MissingItems = Compare-CheckItems -BaseItems $BaseItems `
                                           -CompareItems $CriticalItemList,
                                                         $ImportantItemList `
                                           -Missing

        if ($MissingItems.Count -gt 0) {
            Add-OutputEntry -State $CheckOptions.MissingState `
                            -Message $CheckOptions.MessageMissing `
                            -Items $MissingItems
        }
    }


    # ImportantItems
    if ($CheckOptions.Inverse) {
        # Only return items that are MISSING from $MatchItems
        $MatchedImportantItems = Compare-CheckItems `
                                              -BaseItems $MatchItems `
                                              -CompareItems $ImportantItemList `
                                              -Missing

    } else {
        # Return items that match those in $MatchItems
        $MatchedImportantItems = Compare-CheckItems `
                                              -BaseItems $MatchItems `
                                              -CompareItems $ImportantItemList
                             
    }

    if ($MatchedImportantItems.Count -gt 0) {
        Add-OutputEntry -State 1 -Items $MatchedImportantItems
    }



    # CriticalItems
    if ($CheckOptions.Inverse) {
        # Only return items that are MISSING from $MatchItems
        $MatchedCriticalItems = Compare-CheckItems `
                                             -BaseItems $MatchItems `
                                             -CompareItems $CriticalItemList `
                                             -Missing
    } else {
        # Return items that match those in $MatchItems
        $MatchedCriticalItems = Compare-CheckItems `
                                             -BaseItems $MatchItems `
                                             -CompareItems $CriticalItemList
    }

    if ($MatchedCriticalItems.Count -gt 0) {
        Add-OutputEntry -State 2 -Items $MatchedCriticalItems
    }



    # No issues so far!
    if ($Output.Count -eq 0) {
        Add-OutputEntry -State 0
    }

    Write-CheckResult

}

#ENDREGION Functions


#REGION Main

# Run 'Invoke-Main' if run directly, but don't if imported.
# (Python way is best way)
$Imported = $MyInvocation.InvocationName -eq '.'
if (!$Imported) { 
    Invoke-Main -CriticalItems $CriticalItems `
                -ImportantItems $ImportantItems
}