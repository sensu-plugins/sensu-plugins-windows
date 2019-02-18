#! /usr/bin/env ruby
# frozen_string_literal: false

#
#   metric-windows-cpu-load.rb
#
# DESCRIPTION:
#   This plugin collects and outputs the CPU load in a Graphite acceptable format.
#   It uses Typeperf to get the processor usage.
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
#   Released under the same terms as Sensu (the MIT license); see LICENSE for details.
#
require 'sensu-plugin/metric/cli'
require 'socket'

class CpuMetric < Sensu::Plugin::Metric::CLI::Graphite
  option :scheme,
         description: 'Metric naming scheme, text to prepend to .$parent.$child',
         long: '--scheme SCHEME',
         default: Socket.gethostname.to_s

  def acquire_cpu_load
    temp_arr = []
    timestamp = Time.now.utc.to_i
    IO.popen('typeperf -sc 1 "processor(_total)\\% processor time" ') { |io| io.each { |line| temp_arr.push(line) } }
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
