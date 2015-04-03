## Sensu-Plugins-windows

[![Build Status](https://travis-ci.org/sensu-plugins/sensu-plugins-windows.svg?branch=master)](https://travis-ci.org/sensu-plugins/sensu-plugins-windows)
[![Gem Version](https://badge.fury.io/rb/sensu-plugins-windows.svg)](http://badge.fury.io/rb/sensu-plugins-windows)
[![Code Climate](https://codeclimate.com/github/sensu-plugins/sensu-plugins-windows/badges/gpa.svg)](https://codeclimate.com/github/sensu-plugins/sensu-plugins-windows)
[![Test Coverage](https://codeclimate.com/github/sensu-plugins/sensu-plugins-windows/badges/coverage.svg)](https://codeclimate.com/github/sensu-plugins/sensu-plugins-windows)
[![Dependency Status](https://gemnasium.com/sensu-plugins/sensu-plugins-windows.svg)](https://gemnasium.com/sensu-plugins/sensu-plugins-windows)

## Functionality

## Files
 * bin/metrics-windows-ram-usage.rb
 * bin/metrics-windows-cpu-load.rb
 * bin/metrics-windows-disk-usage.rb
 * bin/metrics-iis-get-requests.rb
 * bin/metrics-iis-current-connections.rb
 * bin/check-windows-service.rb
 * bin/check-windows-process.rb
 * bin/extension-wmi-metrics.rb
 * bin/check-windows-disk.rb
 * bin/check-windows-cpu-load.rb
 * bin/check-iis-current-connections.rb

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
  version '0.0.1.alpha.1'
end
```

Using the Chef **gem_package** resource
```
gem_package 'sensu-plugins-windows' do
  options('--prerelease')
  version '0.0.1.alpha.1'
end
```

## Notes
