#! /usr/bin/env ruby
#
#   metrics-windows-cpu-load.rb
#
# DESCRIPTION:
#   This is metrics which outputs the CPU load in Graphite acceptable format.
#   To get the cpu stats for Windows Server to send over to Graphite.
#   It basically uses the typeperf to get the processor usage at a given particular time.
#
# OUTPUT:
#   metric data
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
#   Copyright 2013 <jashishtech@gmail.com>
#   Released under the same terms as Sensu (the MIT license); see LICENSE
#   for details.
#

require 'sensu-plugin/metric/cli'
require 'socket'

#
# Cpu metric
#
class CpuMetric < Sensu::Plugin::Metric::CLI::Graphite
  option :scheme,
         description: 'Metric naming scheme, text to prepend to .$parent.$child',
         long: '--scheme SCHEME',
         default: Socket.gethostname.to_s

  def acquire_cpu_load

    # The 'typeperf' command to use to get the cpu load
    typeperf_command = 'typeperf -sc 1 "processor(_total)\\% processor time" '

    # The language configured on the Operating System
    language = 'English'

    # Trick to know in which language is the current system, we read the help of the
    # 'typeperf' command and identify patterns to know in which language the
    # Operating System is configured
    help = IO.popen('typeperf -h').readlines.join("")
    if help.include? "Compteurs de performances"
      typeperf_command = 'typeperf -sc 1 "processeur(_total)\\% temps processeur"'
    end
    
    temp_arr = []
    timestamp = Time.now.utc.to_i
    IO.popen(typeperf_command) { |io| io.each { |line| temp_arr.push(line) } }
    temp = temp_arr[2].split(',')[1]
    cpu_metric = temp[1, temp.length - 3].to_f
    [cpu_metric, timestamp]
  end

  def run
    values = acquire_cpu_load
    metrics = {
      cpu: {
        loadavgsec: values[0]
      }
    }
    metrics.each do |parent, children|
      children.each do |child, value|
        output [config[:scheme], parent, child].join('.'), value, values[1]
      end
    end
    ok
  end
end
