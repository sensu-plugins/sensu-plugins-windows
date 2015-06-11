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
         default: "#{Socket.gethostname}"

  def acquire_uptime
    temp_arr = []
    IO.popen("typeperf -sc 1 \"\\System\\System Up Time\" ") { |io| io.each { |line| temp_arr.push(line) } }
    date_str, uptime_str = temp_arr[2].split(',')
    uptime = uptime_str.strip[1, uptime_str.length - 3]
    [uptime, Time.parse(date_str).to_f]
  end

  def run
    # To get the uptime usage
    values = acquire_uptime
    output [config[:scheme], 'system', 'uptime'].join('.'), values[0], values[1]
    ok
  end
end
