## Sensu-Plugins-windows

[![Build Status](https://travis-ci.org/sensu-plugins/sensu-plugins-windows.svg?branch=master)](https://travis-ci.org/sensu-plugins/sensu-plugins-windows)
[![Gem Version](https://badge.fury.io/rb/sensu-plugins-windows.svg)](http://badge.fury.io/rb/sensu-plugins-windows)
[![Code Climate](https://codeclimate.com/github/sensu-plugins/sensu-plugins-windows/badges/gpa.svg)](https://codeclimate.com/github/sensu-plugins/sensu-plugins-windows)
[![Test Coverage](https://codeclimate.com/github/sensu-plugins/sensu-plugins-windows/badges/coverage.svg)](https://codeclimate.com/github/sensu-plugins/sensu-plugins-windows)
[![Dependency Status](https://gemnasium.com/sensu-plugins/sensu-plugins-windows.svg)](https://gemnasium.com/sensu-plugins/sensu-plugins-windows)

## Functionality

## Files
 * bin/metrics-windows-ram-usage
 * bin/metrics-windows-cpu-load
 * bin/metrics-windows-disk-usage
 * bin/metrics-iis-get-requests
 * bin/metrics-iis-current-connections
 * bin/check-windows-service
 * bin/check-windows-process
 * bin/extension-wmi-metrics
 * bin/check-windows-disk
 * bin/check-windows-cpu-load
 * bin/check-iis-current-connections

## Usage

## Installation

Add the public key (if you haven’t already) as a trusted certificate

```
gem cert --add <(curl -Ls https://raw.githubusercontent.com/sensu-plugins/sensu-plugins.github.io/master/certs/sensu-plugins.pem)
gem install sensu-plugins-windows -P MediumSecurity
```

You can also download the key from /certs/ within each repository.

#### Rubygems

`gem install sensu-plugins-windows`

#### Bundler

Add *sensu-plugins-windows* to your Gemfile and run `bundle install` or `bundle update`

#### Chef

Using the Sensu **sensu_gem** LWRP
```
sensu_gem 'sensu-plugins-windows' do
  options('--prerelease')
  version '0.0.1.alpha.4'
end
```

Using the Chef **gem_package** resource
```
gem_package 'sensu-plugins-windows' do
  options('--prerelease')
  version '0.0.1.alpha.4'
end
```

## Notes
