## Sensu-Plugins-Windows

[![Build Status](https://travis-ci.org/sensu-plugins/sensu-plugins-windows.svg?branch=master)](https://travis-ci.org/sensu-plugins/sensu-plugins-windows)
[![Gem Version](https://badge.fury.io/rb/sensu-plugins-windows.svg)](http://badge.fury.io/rb/sensu-plugins-windows)
[![Appveyor status](https://ci.appveyor.com/api/projects/status/j6cg9tmxs6ivscrd/branch/master?svg=true)](https://ci.appveyor.com/project/majormoses/sensu-plugins-windows/branch/master)
[![Community Slack](https://slack.sensu.io/badge.svg)](https://slack.sensu.io/badge)

## Functionality

These files provide basic Checks and Metrics for a Windows system.

## Files

### Ruby

 * bin/check-windows-cpu-load.rb
 * bin/check-windows-disk.rb
 * bin/check-windows-process.rb
 * bin/check-windows-processor-queue-length.rb
 * bin/check-windows-ram.rb
 * bin/check-windows-service.rb
 * bin/metric-windows-cpu-load.rb
 * bin/metric-windows-disk-usage.rb
 * bin/metric-windows-network.rb
 * bin/metric-windows-processor-queue-length.rb
 * bin/metric-windows-ram-usage.rb
 * bin/metric-windows-uptime.rb
 * bin/powershell_helper.rb

### Powershell

 * bin/check-windows-cpu-load.ps1
 * bin/check-windows-disk.ps1
 * bin/check-windows-disk-writeable.ps1
 * bin/check-windows-pagefile.ps1
 * bin/check-windows-process.ps1
 * bin/check-windows-processor-queue-length.ps1
 * bin/check-windows-ram.ps1
 * bin/check-windows-service.ps1
 * bin/metric-windows-cpu-load.ps1
 * bin/metric-windows-disk-usage.ps1
 * bin/metric-windows-network.ps1
 * bin/metric-windows-processor-queue-length.ps1
 * bin/metric-windows-ram-usage.ps1
 * bin/metric-windows-uptime.ps1
 * bin/check-windows-directory.ps1
 * bin/check-windows-event-log.ps1
 * bin/check-windows-log.ps1


## Usage

##### Example 1:

Execute Powershell functions using the helper (No copy needed), see example below:

```json
  {
    "checks": {
      "cpu_percent": {
        "command": "c:\\opt\\sensu\\embedded\\bin\\ruby C:\\opt\\sensu\\embedded\\bin\\powershell_helper.rb check-windows-ram.ps1 90 95",
        "interval": 30,
        "type": "check",
        "handler": "win_metrics",
        "subscribers": ["win_metrics"]
      }
    }
  }
```

##### Example 2:

- Copy either the Ruby or Powershell files on a Sensu Client, typically under C:\etc\sensu\plugins.

- You should also include the full escaped path to the ruby interpreter in the check's command configuration, see example below:

```json
  {
    "checks": {
      "cpu_percent": {
        "command": "c:\\opt\\sensu\\embedded\\bin\\ruby C:\\opt\\sensu\\etc\\plugins\\metric-windows-cpu-load.rb",
        "interval": 30,
        "type": "metric",
        "handler": "win_metrics",
        "subscribers": ["win_metrics"]
      }
    }
  }
```

You should also include the full escaped path to the ruby interpreter in the check's command configuration, see example below:

```json
{
  "checks": {
    "cpu_percent": {
      "command": "c:\\opt\\sensu\\embedded\\bin\\ruby C:\\opt\\sensu\\etc\\plugins\\metric-windows-cpu-load.rb",
      "interval": 30,
      "type": "metric",
      "handler": "win_metrics",
      "subscribers": ["win_metrics"]
    }
  }
}
```

## Dependencies
 * Powershell checks require Powershell version 3.0 or higher.

## Troubleshooting
* Failures to pull counter data with messages like below, might be due to corrupt performance counters. See [Here](https://support.microsoft.com/en-us/help/2554336/how-to-manually-rebuild-performance-counters-for-windows-server-2008-6) for more information.  Short answer on fix is `lodctr /R` in an Admin elevated command prompt

`Check failed to run: undefined method length' for nil:NilClass, "c:/opt/sensu/plugins/check-windows-ram.rb:45:inacquire_ram_usage'", "c:/opt/sensu/plugins/check-windows-ram.rb:54:in run'", "c:/opt/sensu/embedded/lib/ruby/gems/2.0.0/gems/sensu-plugin-1.`

## Testing

### Installation and Updates

Windows Platform testing is moving to Pester as Powershell is the native language for the OS.

All tests should be written using Pester 4 syntax. For the differences please read [this](https://github.com/pester/Pester/wiki/Migrating-from-Pester-3-to-Pester-4)

In Windows 10 v1809 and higher, you first need to cleanup the default Pester module and only then you can proceed with the installation of higher version of Pester module.

```powershell
$module = "C:\Program Files\WindowsPowerShell\Modules\Pester"
takeown /F $module /A /R
icacls $module /reset
icacls $module /grant Administrators:'F' /inheritance:d /T
Remove-Item -Path $Module -Recurse -Force -Confirm:$false

Install-Module -Name Pester -Force
```

For any subsequent update it is enough to run:

```powershell
Update-Module -Name Pester
```

### Running Tests

From the root directory run

```powershell
Invoke-Pester
```

## Installation

[Installation and Setup](http://sensu-plugins.io/docs/installation_instructions.html)
