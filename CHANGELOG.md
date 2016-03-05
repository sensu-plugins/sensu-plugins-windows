#Change Log
This project adheres to [Semantic Versioning](http://semver.org/).

This CHANGELOG follows the format listed at [Keep A Changelog](http://keepachangelog.com/)

## 

## [0.0.10] - 2016-02-16
### Fixed
- check-windows-disk.rb removed system volumes from list

## [0.0.9] - 2016-02-05
### Added
- new certs

## [0.0.8] - 2015-12-10
### Fixed
- metrics-windows-disk-usage.rb incorrect variable

## [0.0.7] - 2015-11-19
### Fixed
- metrics-windows-network.rb: remove characters that break graphite metrics

## [0.0.6] - 2015-08-04
### Changed
- updated check-windows-process to use native WMI hooks
- bump rubocop
- change binstubs to only be created for ruby files

## [0.0.5] - 2015-07-14
### Changed
- updated sensu-plugin gem to 1.2.0

## [0.0.4] - 2015-07-05
### Added
- windows uptime metrics
- windows RAM metrics
- windows network metrics

### Removed
- removed IIS check / metrics plugins and moved them to their own sensu iis plugin repository

## [0.0.3]
- Pulled

## [0.0.2] - 2015-06-03
### Fixed
- added binstubs

### Changed
- removed cruft from /lib

## 0.0.1 - 2015-05-21
### Added
- initial release

[Unreleased]: https://github.com/sensu-plugins/sensu-plugins-windows/compare/v0.0.10...HEAD
[0.0.10]: https://github.com/sensu-plugins/sensu-plugins-windows/compare/v0.0.9...v0.0.10
[0.0.9]: https://github.com/sensu-plugins/sensu-plugins-windows/compare/0.0.8..v0.0.9
[0.0.8]: https://github.com/sensu-plugins/sensu-plugins-windows/compare/0.0.7...0.0.8
[0.0.7]: https://github.com/sensu-plugins/sensu-plugins-windows/compare/0.0.6...0.0.7
[0.0.6]: https://github.com/sensu-plugins/sensu-plugins-windows/compare/0.0.5...0.0.6
[0.0.5]: https://github.com/sensu-plugins/sensu-plugins-windows/compare/0.0.4...0.0.5
[0.0.4]: https://github.com/sensu-plugins/sensu-plugins-windows/compare/0.0.3...0.0.4
[0.0.4]: https://github.com/sensu-plugins/sensu-plugins-windows/compare/0.0.2...0.0.3
[0.0.2]: https://github.com/sensu-plugins/sensu-plugins-windows/compare/0.0.1...0.0.2
