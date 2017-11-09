# check-multi-template

A Sensu Powershell template.

## Overview

The `check-multi-template` is designed to provide a single base template for
PowerShell plugins, reducing uneccessary boilerplate and providing a base set of
features and expecations that make it easier to write checks. In particular, the
plugins based upon the template can consume multiple items to be checked - 
Please see *Paramaters* heading for more info.

The template itself can be copied, altered and used directly, but it is more 
effective to import it and use it as a template.

## Usage

Take a look at any of the other checks in this directory (eg. 
`check-adapters.ps1`), and you will see they all include the following elements:

  - **Parameter block** - Arguments provided from the CLI. Please see 
  *Parameters* heading for more info.
  - **Template import** - Dot source import of the template from the same folder
  as the plugin. This imports all of of the default options and all functions.
  - **CheckOptions hashtable** - Configuration for the check. Overrides defaults
  from the template.
  - **Call to `Invoke-Main` function** - Along with the parameters to be 
  consumed, eg.
  `Invoke-Main -CriticalItems $CriticalAdapters -ImportantItems $ImportantAdapters`

## Features

The crux of the template logic comes from simply comparing the values in arrays -
 one consisting of values that have been passed in via. command-line arguments,
the other consisting of items in a specific state.

If you look in the function `Invoke-Main`, you will see 3 main steps in 
determining service health:

  - Compare all items passed in via. CLI parameters (`ImportantItems` & 
  `CriticalItems`) against `BaseItems` array. This first checks to see if any of
  the items are missing. This can be disabled by changing 
  `$CheckOptions.CheckMissing` to `$False`.

  - Compare `ImportantItems` against `FailedItems` array.

  - Compare `CriticalItems` against `FailedItems` array.

And these arrays are populated via. the scriptblocks (Anonymous functions) in
`$CheckOptions`. For example, the scriptblocks used in `check-adapters` are:

```powershell
'ScriptBlockBaseItems' = {
    Get-NetAdapter |
    Select-Object -ExpandProperty Name
}

'ScriptBlockFailedItems' = {
    Get-NetAdapter |
    Where-Object { $_.Status -ne 'Up' } |
    Select-Object -ExpandProperty Name
}
```

As you can see, the `ScriptBlockBaseItems` simply gets all network adapters on
the machine and then expands the `Name` property.

The `ScriptBlockFailedItems` simply does the same, but only for adapters with
a state not equal to 'Up'.

Now, we compare our CLI parameters against these, and if any of the items we
passed in are present in `FailedItems`, the script will flag it according to
whether it was part of the `CriticalItems` or `ImportantItems` parameter.

### Inverting the logic

The logic can be reversed but changing `$CheckOptions.Inverse` to `$True`,
meaning that the script will check to see if `ImportantItems` and 
`CriticalItems` are *absent* from `FailedItems`.

An example of this being used is in `check-iscsi.ps1` as it checks to see if
any of the IQNs passed in at the CLI are *absent* from the list of all sessions.

**NOTE:** Inverting the logic will automatically disable the 'missing' check.

### Parameters

Most of the examples will have parameters equivalent to the template's 
`CriticalItems` and `ImportantItems` parameters (eg. `check-adapters.ps1` has 
`CriticalAdapters` and `ImportantAdapters`) which allows the plugin to provide 
a different return value based on whether items were flagged as 'critical' or
'important'.

  > **NOTE:** The highest severity result is taken for the final check result. 
  > This means that if both items in `ImportantItems` and items in 
  > `CriticalItems` are flagged as in a failed state, the overall status will be
  > `CRITICAL:` (Exit code `2`). All failed items will still be shown in the 
  > check output with their respective importance levels.

Additionally, there is some extra processing done in the parameters to
accommodate for multiple instances of Sensu's token substitution. Here is an
excerpt from the help provided in the template detailing this:

> Sensu check token substitution:
>   Because this check is designed to make full use of Sensu's check token 
>   substitution (https://sensuapp.org/docs/latest/reference/checks.html#check-token-substitution)
>   feature, some special considerations have been taken for how the arguments are parsed.
> 
>   The main parameters support a list of of comma-separated strings.
>     eg. -CriticalItems 'value1','value2'
>   They also accepts accept a single string with comma-separated values.
>     eg. -param1 'value1,value2'
>   ...or you can mix & match the two and all of the values will be merged.
>     eg. -param1 'value1','value2,value3'
>   Additionally, any use of the word 'None' will be ignored.
>     eg. -param1 'value1','None,value2','None'
> 
>   This is because Sensu's client attribute substitution tokens only work with 
>   flat strings, but by supporting both of the above methods, it allows the use
>   of multiple values within a single check/client attribute AND multiple
>   different client/check attributes to be used. Additionally, because 'None'
>   is ignored, it allows the user to provide a default value in the check 
>   token substitution, as not to throw an error if the value is missing.
> 
> Token substitution example:
>   Check attribute 'check_attr'   = "alpha,bravo"
>   Client attribute 'client_attr' = "charlie,delta"
> 
>     powershell.exe -File check.ps1 -param1 ":::check_attr|None:::",":::missing_attr|None:::",":::client_attr|None:::"
>     
>   Which evaluates to:
> 
>     powershell.exe -File check.ps1 -param "alpha,bravo","None","charlie,delta"
> 
>   The script then strips any instances of 'None' and processes the 
>   comma-separated string as single flat array.

Here is an example of real-world usage:

```json
{
  "checks": {
    "services-running": {
      "command": "powershell.exe -noprofile -noninteractive -executionpolicy bypass -nologo -file C:\\\\opt\\\\sensu\\\\check-scripts\\\\check-services.ps1 -criticalservices \":::vars.services.critical|None:::,:::vars.services.critical_group|None:::,:::vars.services.critical_all|None:::\" -importantservices \":::vars.services.important|None:::,:::vars.services.important_group|None:::,:::vars.services.important_all|None:::\"",
      "description": "Checks the status of services",
      "handlers": [
        "default"
      ],
      "interval": 60,
      "occurrences": 3,
      "subscribers": [
        "winservers"
      ]
    }
  }
}
```

And within the host's `client.json`:

```json
...
  "vars": {
      "services": {
          "critical": "criticalA,criticalB",
          "critical_group": "criticalC",
          "critical_all": "criticalD,criticalE",
          "important": "importantA,importantB",
          "important_all": "importantD,serviceE"
      }
  }
```

These values are populated by my config-management tool, and it allows me to 
specify values for the host, the host's group (eg. webservers) and all hosts
without Sensu having any issues. As you can see, `important_group` is missing,
but that will simply be substituted with `None` as per the check definition.
