# Change Log
This project adheres to [Semantic Versioning](http://semver.org/).

This CHANGELOG follows the format listed at [Our CHANGELOG Guidelines ](https://github.com/sensu-plugins/community/blob/master/HOW_WE_CHANGELOG.md).
Which is based on [Keep A Changelog](http://keepachangelog.com/)

## [Unreleased]
- update cpu and memory checks to follow comparison operator in linux plugins check (greater than or equal to) (@derekgroh)

## [3.0.0] - 2019-03-04
### Security
- updated yard dependency to `~> 0.9.11` per: https://nvd.nist.gov/vuln/detail/CVE-2017-17042 (@majormoses)
- updated rubocop dependency to `~> 0.51.0` per: https://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2017-8418. (@majormoses)

### Breaking Changes
- drop EOL rubies `< 2.3` (@majormoses)
- bump `sensu-plugin` dependency from `~> 1.2` to `~> 4.0` you can read the changelog entries for [4.0](https://github.com/sensu-plugins/sensu-plugin/blob/master/CHANGELOG.md#400---2018-02-17), [3.0](https://github.com/sensu-plugins/sensu-plugin/blob/master/CHANGELOG.md#300---2018-12-04), and [2.0](https://github.com/sensu-plugins/sensu-plugin/blob/master/CHANGELOG.md#v200---2017-03-29) (@majormoses)
- update cpu and memory checks to follow comparison operator in linux plugins check (greater than or equal to) (@derekgroh)

### Changed
- update `bundler` dependency (@majormoses)
- appeased the cops (@majormoses)

### Removed
- `codeclimate` (@majormoses)

## [2.9.1] - 2019-02-17
### Fixed
- check-windows-disk.rb: use the full path for CSV file path due to a bug in `wmic` (@jasiek191)

## [2.9.0] - 2018-08-24
### Changed
- updated check: `powershell/check-windows-disk-writeable.ps1` now using CIM instead of WMI for large performance gain (@csabo)
- updated check: `powershell/check-windows-disk.ps1` now using CIM instead of WMI for large performance gain (@csabo)
- updated check: `powershell/check-windows-pagefile.ps1` now using CIM instead of WMI for large performance gain (@csabo)
- updated check: `powershell/check-windows-processor-queue-length.ps1` now using CIM instead of WMI for large performance gain (@csabo)
- updated check: `powershell/check-windows-ram.ps1` now using CIM instead of WMI for large performance gain (@csabo)
- updated check: `powershell/metric-windows-disk-usage.ps1` now using CIM instead of WMI for large performance gain (@csabo)
- updated check: `powershell/metric-windows-processor-queue-length.ps1` now using CIM instead of WMI for large performance gain (@csabo)
- updated check: `powershell/metric-windows-ram-usage.ps1` now using CIM instead of WMI for large performance gain (@csabo)



### Added
- README.md, added troubleshooting section with fix for corrupt performance counters [issue #35](https://github.com/sensu-plugins/sensu-plugins-windows/issues/35) (@csabo)

## [2.8.1] - 2018-07-19
### Fixed
- metric-windows-cpu-load.ps1: report the correct metric value for interrupts  (@makaveli0129)
- metric-windows-disk.ps1: fix typo that prevented disk queue length to be reported properly (@makaveli0129)

## [2.8.0] - 2018-05-10
### Added
- check-windows-directory.ps1, added plugin to check if a directory exist (@patricewhite).

## [2.7.0] - 2018-05-09
### Changed
- check-windows-event-log.ps1, added plugin to check for pattern and returns the number criticals and warnings that match that pattern (@patricewhite)

## [2.6.0] - 2018-05-09
### Added
- check-windows-log.ps1, added plugin to check for pattern in log file (@patricewhite).

### Changed
- README.md, changed to include new plugin (@patricewhite).

## [2.5.0] - 2018-05-02
### Added
- powershell_helper.rb, added helper to wrap around Powershell directory (@makaveli0129).

### Changed
- README.md, changed to include calls for powershell_helper.rb (@makaveli0129).

### [2.4.1] - 2018-04-18
### Fixed
- check-windows-http.ps1: fixed typo (@stevebanik-ndsc)

## [2.4.0] - 2017-12-08
### Added
- minimal `appveyor.yml` (@majormoses)
- badges for `slack` and `appveyor` (@majormoses)

## [2.3.0] - 2017-11-12
### Added
- new check: `powershell/check-multi-template/check-processes.ps1` (@absolutejam)
- new check `powershell/check-multi-template/check-services.ps1` (@absolutejam)
- new check `powershell/check-multi-template/check-multi-template.ps1` (@absolutejam)
- new check `powershell/check-multi-template/check-iscsi.ps1` (@absolutejam)
- new check `powershell/check-multi-template/check-focusedprocess.ps1` (@absolutejam)
- new check: `powershell/check-multi-template/check-adapters.ps1` (@absolutejam)
- documentation `powershell/check-multi-template/README.md` (@absolutejam)

## [2.2.1] - 2017-09-25
### Changed
- update changelog guidelines location (@majormoses)
### Fixed
- `check-windows-service.rb`: allow service names to have spaces in them (@bodgit)

## [2.2.0] - 2017-09-08
### Fixed
- added multi language support to all the powershell scripts (@Seji64)
- powershell/metric-windows-network.ps1: handle interfaces with spaces in their name (@Seji64)
- Calculate correct Unix Timestamp (@Seji64)

### Added
- `powershell/perfhelper.ps1`: added standard sensu header (@Seji64)
- added option to enable fdqn in metric path (@Seji64)
- `powershell/metric-windows-disk.ps1` new metric script for disk IO stats (@Seji64)
- `powershell/metric-windows-system.ps1` new metric script for system related stats (@Seji64)


### [2.1.0] - 2017-08-26
### Added
- `powershell/check-windows-pagefile.ps1`: which basically allows checking how much pagefile (aka swap) is in use. (@hulkk)

## [2.0.0] - 2017-06-27
### Fixed
- missing diffs on 1.0 release (@majormoses)

### Breaking Change
- Dependency on Powersehell version 3.0 or above for powershell checks. (@simonsteur)

### Changed
- Updated `README.md` with new requirements. (@simonsteur)

### [1.0.0] 2017-06-26
### Fixed
- fix PR template with correct spelling of Compatibility. The big reason to make this a 1.x is to allow an upcoming breaking change and protecting users from it.

## [0.1.0] 2017-06-2017
### Fixed
- Check-Windows-disk.rb added CSV formatting for WMIC.

### Added
- Windows CPU Load Check written using only Powershell under bin/powershell. (@ajeba99)
- Windows Disk Usage Check written using only Powershell under bin/powershell.
- Windows Disk Writeable written using only Powershell under bin/powershell (@shoekstra)
- Windows Process Check written using only Powershell under bin/powershell.
- Windows RAM Check written using only Powershell under bin/powershell.
- Windows Service Check written using only Powershell under bin/powershell.
- Windows CPU Load Metric written using only Powershell under bin/powershell.
- Windows Disk Usage Metric written using only Powershell under bin/powershell.
- Windows RAM Metric written using only Powershell under bin/powershell.
- Windows Network Metric written using only Powershell under bin/powershell.
- Windows Uptime Metric written using only Powershell under bin/powershell.
- Add support for ignoring disk checks by disk label (via a regular expression) (@manul7)
- Add check-windows-processor-queue-length (@andyroyle)
- Add testing on Ruby 2.3 and 2.4.1 (@eheydrick)

### Changed
- Corrected grammer issues and clarified comments in all existing Ruby-based Windows Check and Metric files.
- Moved existing Ruby-based Windows Check and Metric files to bin/ruby.
- Changed file naming to the singular instead of the difference in plurality between 'check' and 'metrics'.
- Updated README.md.

### Fixed
- Fixed numerous grammar issues in CHANGELOG.md file.

### Removed
- Support for Ruby < 2 (@eheydrick)

## [0.0.10] - 2016-02-16
### Fixed
- Check-Windows-disk.rb removed system volumes from list

## [0.0.9] - 2016-02-05
### Added
- New certs

## [0.0.8] - 2015-12-10
### Fixed
- Metric-Windows-disk-usage.rb incorrect variable

## [0.0.7] - 2015-11-19
### Fixed
- Metric-Windows-network.rb: remove characters that break graphite metrics

## [0.0.6] - 2015-08-04
### Changed
- Updated check-Windows-process to use native WMI hooks
- Bump rubocop
- Change binstubs to only be created for ruby files

## [0.0.5] - 2015-07-14
### Changed
- Updated Sensu-plugin gem to 1.2.0

## [0.0.4] - 2015-07-05
### Added
- Windows Uptime Metrics
- Windows RAM Metrics
- Windows Network Metrics

### Removed
- Removed IIS check / metrics plugins and moved them to their own sensu iis plugin repository

## [0.0.3]
- Pulled

## [0.0.2] - 2015-06-03
### Fixed
- Added binstubs

### Changed
- Removed cruft from /lib

## 0.0.1 - 2015-05-21
### Added
- Initial release

[Unreleased]: https://github.com/sensu-plugins/sensu-plugins-Windows/compare/3.0.0...HEAD
[3.0.0]: https://github.com/sensu-plugins/sensu-plugins-Windows/compare/2.9.1...3.0.0
[2.9.1]: https://github.com/sensu-plugins/sensu-plugins-Windows/compare/2.9.0...2.9.1
[2.9.0]: https://github.com/sensu-plugins/sensu-plugins-Windows/compare/2.8.1...2.9.0
[2.8.1]: https://github.com/sensu-plugins/sensu-plugins-Windows/compare/2.8.0...2.8.1
[2.8.0]: https://github.com/sensu-plugins/sensu-plugins-Windows/compare/2.7.0...2.8.0
[2.7.0]: https://github.com/sensu-plugins/sensu-plugins-Windows/compare/2.6.0...2.7.0
[2.6.0]: https://github.com/sensu-plugins/sensu-plugins-Windows/compare/2.5.0...2.6.0
[2.5.0]: https://github.com/sensu-plugins/sensu-plugins-Windows/compare/2.4.1...2.5.0
[2.4.1]: https://github.com/sensu-plugins/sensu-plugins-Windows/compare/2.4.0...2.4.1
[2.4.0]: https://github.com/sensu-plugins/sensu-plugins-Windows/compare/2.3.0...2.4.0
[2.3.0]: https://github.com/sensu-plugins/sensu-plugins-Windows/compare/2.2.1...2.3.0
[2.2.1]: https://github.com/sensu-plugins/sensu-plugins-Windows/compare/2.2.0...2.2.1
[2.2.0]: https://github.com/sensu-plugins/sensu-plugins-Windows/compare/2.1.0...2.2.0
[2.1.0]: https://github.com/sensu-plugins/sensu-plugins-Windows/compare/2.0.0...2.1.0
[2.0.0]: https://github.com/sensu-plugins/sensu-plugins-Windows/compare/1.0.0...2.0.0
[1.0.0]: https://github.com/sensu-plugins/sensu-plugins-Windows/compare/0.1.0...1.0.0
[0.1.0]: https://github.com/sensu-plugins/sensu-plugins-Windows/compare/v0.0.10...0.1.0
[0.0.10]: https://github.com/sensu-plugins/sensu-plugins-Windows/compare/v0.0.9...v0.0.10
[0.0.9]: https://github.com/sensu-plugins/sensu-plugins-Windows/compare/0.0.8..v0.0.9
[0.0.8]: https://github.com/sensu-plugins/sensu-plugins-Windows/compare/0.0.7...0.0.8
[0.0.7]: https://github.com/sensu-plugins/sensu-plugins-Windows/compare/0.0.6...0.0.7
[0.0.6]: https://github.com/sensu-plugins/sensu-plugins-Windows/compare/0.0.5...0.0.6
[0.0.5]: https://github.com/sensu-plugins/sensu-plugins-Windows/compare/0.0.4...0.0.5
[0.0.4]: https://github.com/sensu-plugins/sensu-plugins-Windows/compare/0.0.3...0.0.4
[0.0.4]: https://github.com/sensu-plugins/sensu-plugins-Windows/compare/0.0.2...0.0.3
[0.0.2]: https://github.com/sensu-plugins/sensu-plugins-Windows/compare/0.0.1...0.0.2
