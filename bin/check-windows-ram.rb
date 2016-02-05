#! /usr/bin/env ruby
#
#   check-windows-ram.rb
#
# DESCRIPTION:
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
#  Tested on Windows 2008RC2.
#
# LICENSE:
#   Jean-Francois Theroux <me@failshell.io>
#   Released under the same terms as Sensu (the MIT license); see LICENSE
#   for details.
#

require 'sensu-plugin/check/cli'

#
# Check Windows RAM Load
#
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
    temp_arr_1 = []
    temp_arr_2 = []
    IO.popen('typeperf -sc 1 "Memory\\Available bytes" ') { |io| io.each { |line| temp_arr_1.push(line) } }
    temp = temp_arr_1[2].split(',')[1]
    ram_available_in_bytes = temp[1, temp.length - 3].to_f
    IO.popen('wmic OS get TotalVisibleMemorySize /Value') { |io| io.each { |line| temp_arr_2.push(line) } }
    total_ram = temp_arr_2[4].split('=')[1].to_f
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
