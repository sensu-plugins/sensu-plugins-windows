#! /usr/bin/env ruby
#
#   check-windows-cpu-load.rb
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
# Check Windows CPU Load
#
class CheckWindowsCpuLoad < Sensu::Plugin::Check::CLI
  option :warning,
         short: '-w WARNING',
         default: 85,
         proc: proc(&:to_i)

  option :critical,
         short: '-c CRITICAL',
         default: 95,
         proc: proc(&:to_i)

  def run

    # The 'typeperf' command to use to get the cpu load
    typeperf_command = 'typeperf -sc 1 "processor(_total)\\% processor time"'

    # The language configured on the Operating System
    language = 'English'

    # Trick to know in which language is the current system, we read the help of the
    # 'typeperf' command and identify patterns to know in which language the
    # Operating System is configured
    help = IO.popen('typeperf -h').readlines.join("")
    if help.include? "Compteurs de performances"
      typeperf_command = 'typeperf -sc 1 "processeur(_total)\\% temps processeur"'
    end

    io = IO.popen(typeperf_command)
    cpu_load = io.readlines[2].split(',')[1].delete('"').to_i
    critical "CPU at #{cpu_load}%" if cpu_load > config[:critical]
    warning "CPU at #{cpu_load}%" if cpu_load > config[:warning]
    ok "CPU at #{cpu_load}%"
  end
end
