#Change Log
This project adheres to [Semantic Versioning](http://semver.org/).

This CHANGELOG follows the format listed at [Keep A Changelog](http://keepachangelog.com/).

## [Unreleased]
### Added
- check-windows-processor-queue-length

### Changed
- Adding support for ignoring disk checks by disk label (via a regular expression)

### Fixed
- Check-Windows-disk.rb added CSV formatting for WMIC.

## [0.0.11] - 2016-07-15
### Added
- Windows CPU Load Check written using only Powershell under bin/powershell.
- Windows Disk Usage Check written using only Powershell under bin/powershell.
- Windows Process Check written using only Powershell under bin/powershell.
- Windows RAM Check written using only Powershell under bin/powershell.
- Windows Service Check written using only Powershell under bin/powershell.
- Windows CPU Load Metric written using only Powershell under bin/powershell.
- Windows Disk Usage Metric written using only Powershell under bin/powershell.
- Windows RAM Metric written using only Powershell under bin/powershell.
- Windows Network Metric written using only Powershell under bin/powershell.
- Windows Uptime Metric written using only Powershell under bin/powershell.

### Changed
- Corrected grammer issues and clarified comments in all existing Ruby-based Windows Check and Metric files.
- Moved existing Ruby-based Windows Check and Metric files to bin/ruby.
- Changed file naming to the singular instead of the difference in plurality between 'check' and 'metrics'.
- Updated README.md.

### Fixed
- Fixed numerous grammar issues in CHANGELOG.md file.

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

[Unreleased]: https://github.com/sensu-plugins/sensu-plugins-Windows/compare/v0.0.10...HEAD
[0.0.11]: https://github.com/sensu-plugins/sensu-plugins-Windows/compare/v0.0.10...v0.0.11
[0.0.10]: https://github.com/sensu-plugins/sensu-plugins-Windows/compare/v0.0.9...v0.0.10
[0.0.9]: https://github.com/sensu-plugins/sensu-plugins-Windows/compare/0.0.8..v0.0.9
[0.0.8]: https://github.com/sensu-plugins/sensu-plugins-Windows/compare/0.0.7...0.0.8
[0.0.7]: https://github.com/sensu-plugins/sensu-plugins-Windows/compare/0.0.6...0.0.7
[0.0.6]: https://github.com/sensu-plugins/sensu-plugins-Windows/compare/0.0.5...0.0.6
[0.0.5]: https://github.com/sensu-plugins/sensu-plugins-Windows/compare/0.0.4...0.0.5
[0.0.4]: https://github.com/sensu-plugins/sensu-plugins-Windows/compare/0.0.3...0.0.4
[0.0.4]: https://github.com/sensu-plugins/sensu-plugins-Windows/compare/0.0.2...0.0.3
[0.0.2]: https://github.com/sensu-plugins/sensu-plugins-Windows/compare/0.0.1...0.0.2
