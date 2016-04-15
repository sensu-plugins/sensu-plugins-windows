#! /usr/bin/env ruby
#
#   uptime-windows
#
# DESCRIPTION:
#   This is metrics which outputs the uptime in seconds in Graphite acceptable format.
#
# OUTPUT:
#   metric data
#
# PLATFORMS:
#   Windows
#
# DEPENDENCIES:
#   gem: sensu-plugin
#   gem: socket
#
# USAGE:
#
# NOTES:
#
# LICENSE:
#   Copyright 2015 <miguelangel.garcia@gmail.com>
#   Released under the same terms as Sensu (the MIT license); see LICENSE
#   for details.
#

require 'rubygems' if RUBY_VERSION < '1.9.0'
require 'sensu-plugin/metric/cli'
require 'socket'
require 'time'

class UptimeMetric < Sensu::Plugin::Metric::CLI::Graphite
  option :scheme,
         description: 'Metric naming scheme, text to prepend to .$parent.$child',
         long: '--scheme SCHEME',
         default: "#{Socket.gethostname}.system"

  def acquire_uptime
    # The 'typeperf' command to use to get the uptime
    typeperf_command = 'typeperf -sc 1 "\\System\\System Up Time" '

    # Trick to know in which language is the current system, we read the help of the
    # 'typeperf' command and identify patterns to know in which language the
    # Operating System is configured
    help = IO.popen('typeperf -h').readlines.join('')
    if help.include? 'Compteurs de performances'
      typeperf_command = 'typeperf -sc 1 "Système\Temps d’activité système"'
    end

    temp_arr = []
    timestamp = Time.now.utc.to_i
    IO.popen(typeperf_command) { |io| io.each { |line| temp_arr.push(line) } }
    uptime_str = temp_arr[2].split(',')[1]
    uptime = uptime_str.strip[1, uptime_str.length - 3]
    [format('%.2f', uptime), timestamp]
  end

  def run
    # To get the uptime usage
    values = acquire_uptime
    output [config[:scheme], 'uptime'].join('.'), values[0], values[1]
    ok
  end
end
