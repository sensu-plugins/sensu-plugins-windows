#! /usr/bin/env ruby
# frozen_string_literal: false

#
#   check-windows-ram.rb
#
# DESCRIPTION:
#   This plugin collects and outputs the RAM usage in a Graphite acceptable format.
#   It uses Typeperf to get available memory and WMIC to get the usable memory size.
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
#   Tested on Windows 2008RC2.
#
# LICENSE:
#   Jean-Francois Theroux <me@failshell.io>
#   Released under the same terms as Sensu (the MIT license); see LICENSE for details.
#
require 'sensu-plugin/check/cli'

class CheckWindowsRAMLoad < Sensu::Plugin::Check::CLI
  option :warning,
         short: '-w WARNING',
         default: 85,
         proc: proc(&:to_i)

  option :critical,
         short: '-c CRITICAL',
         default: 95,
         proc: proc(&:to_i)

  def acquire_ram_usage
    temp_arr1 = []
    temp_arr2 = []
    IO.popen('typeperf -sc 1 "Memory\\Available bytes" ') { |io| io.each { |line| temp_arr1.push(line) } }
    temp = temp_arr1[2].split(',')[1]
    ram_available_in_bytes = temp[1, temp.length - 3].to_f
    IO.popen('wmic OS get TotalVisibleMemorySize /Value') { |io| io.each { |line| temp_arr2.push(line) } }
    total_ram = temp_arr2[4].split('=')[1].to_f
    total_ram_in_bytes = total_ram * 1000.0
    ram_use_percent = (total_ram_in_bytes - ram_available_in_bytes) * 100.0 / total_ram_in_bytes
    ram_use_percent.round(2)
  end

  def run
    ram_load = acquire_ram_usage
    critical "RAM at #{ram_load}%" if ram_load > config[:critical]
    warning "RAM at #{ram_load}%" if ram_load > config[:warning]
    ok "RAM at #{ram_load}%"
  end
end
