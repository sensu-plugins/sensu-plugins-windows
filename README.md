## Sensu-Plugins-windowss

[![Build Status](https://travis-ci.org/sensu-plugins/sensu-plugins-windowss.svg?branch=master)](https://travis-ci.org/sensu-plugins/sensu-plugins-windowss)
[![Gem Version](https://badge.fury.io/rb/sensu-plugins-windowss.svg)](http://badge.fury.io/rb/sensu-plugins-windowss)
[![Code Climate](https://codeclimate.com/github/sensu-plugins/sensu-plugins-windowss/badges/gpa.svg)](https://codeclimate.com/github/sensu-plugins/sensu-plugins-windowss)
[![Test Coverage](https://codeclimate.com/github/sensu-plugins/sensu-plugins-windowss/badges/coverage.svg)](https://codeclimate.com/github/sensu-plugins/sensu-plugins-windowss)
[![Dependency Status](https://gemnasium.com/sensu-plugins/sensu-plugins-windowss.svg)](https://gemnasium.com/sensu-plugins/sensu-plugins-windowss)

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

Add *sensu-plugins-windowss* to your Gemfile and run `bundle install` or `bundle update`

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
