## Sensu-Plugins-Windows

[![Build Status](https://travis-ci.org/sensu-plugins/sensu-plugins-windows.svg?branch=master)](https://travis-ci.org/sensu-plugins/sensu-plugins-windows)
[![Gem Version](https://badge.fury.io/rb/sensu-plugins-windows.svg)](http://badge.fury.io/rb/sensu-plugins-windows)
[![Code Climate](https://codeclimate.com/github/sensu-plugins/sensu-plugins-windows/badges/gpa.svg)](https://codeclimate.com/github/sensu-plugins/sensu-plugins-windows)
[![Test Coverage](https://codeclimate.com/github/sensu-plugins/sensu-plugins-windows/badges/coverage.svg)](https://codeclimate.com/github/sensu-plugins/sensu-plugins-windows)
[![Dependency Status](https://gemnasium.com/sensu-plugins/sensu-plugins-windows.svg)](https://gemnasium.com/sensu-plugins/sensu-plugins-windows)
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

 * bin/powershell/check-windows-cpu-load.ps1
 * bin/powershell/check-windows-disk.ps1
 * bin/powershell/check-windows-disk-writeable.ps1
 * bin/powershell/check-windows-pagefile.ps1
 * bin/powershell/check-windows-process.ps1
 * bin/powershell/check-windows-processor-queue-length.ps1
 * bin/powershell/check-windows-ram.ps1
 * bin/powershell/check-windows-service.ps1
 * bin/powershell/metric-windows-cpu-load.ps1
 * bin/powershell/metric-windows-disk-usage.ps1
 * bin/powershell/metric-windows-network.ps1
 * bin/powershell/metric-windows-processor-queue-length.ps1
 * bin/powershell/metric-windows-ram-usage.ps1
 * bin/powershell/metric-windows-uptime.ps1
 * bin/powershell/check-windows-directory.ps1
 * bin/powershell/check-windows-event-log.ps1
 * bin/powershell/check-windows-log.ps1


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

## Installation

[Installation and Setup](http://sensu-plugins.io/docs/installation_instructions.html)
