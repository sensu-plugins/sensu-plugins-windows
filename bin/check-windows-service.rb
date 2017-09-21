#! /usr/bin/env ruby
#
#   check-windows-service.rb
#
# DESCRIPTION:
#   This plugin checks whether a User-supplied service on Windows is running or not
#   This checks users tasklist tool to find any service on Windows is running or not.
#
# OUTPUT:
#   plain text
#
# PLATFORMS:
#   Windows
#
# DEPENDENCIES:
#   gem: sensu-plugin
#
# USAGE:
#
# NOTES:
#
# LICENSE:
#   Edited from <jashishtech@gmail.com>
#   Copyright 2014 <jj.asghar@peopleadmin.com>
#   Released under the same terms as Sensu (the MIT license); see LICENSE for details.
#
require 'sensu-plugin/check/cli'

class CheckWinService < Sensu::Plugin::Check::CLI
  option :service,
         description: 'Check for a specific service',
         long: '--service SERVICE',
         short: '-s SERVICE'

  def run
    temp = system('tasklist /svc|findstr /i /c:"' + config[:service] + '"')
    if temp == false
      message config[:service] + ' is not running'
      critical
    else
      message config[:service] + ' is running'
      ok
    end
  end
end
