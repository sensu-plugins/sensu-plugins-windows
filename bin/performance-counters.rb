#! /usr/bin/env ruby
#
#   metrics.rb
#
# DESCRIPTION:
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
# A configuration file is required. It should be a YAML with this structure:
#   ---
#   PERFORMANCE COUNTER:
#     scheme: RELATIVE.SCHEME
#     min: VALUE
#     max: VALUE
#   ...
#
# Just the performance counter is mandatory. The rest is optional and his meaning is:
# - scheme: relative scheme to be used. It will use the performance counter name if empty.
# - min: checks the value to be higher than this or fails.
# - max: checks the value to be lower than this or fails.
#
# NOTES:
#  Tested on Windows 2012RC2.
#
# LICENSE:
#   Miguel Angel Garcia <miguelangel.garcia@gmail.com>
#   Released under the same terms as Sensu (the MIT license); see LICENSE
#   for details.
#

require 'sensu-plugin/metric/cli'
require 'socket'
require 'yaml'
require 'csv'

#
# Generic Metrics
#
class GenericMetric < Sensu::Plugin::Metric::CLI::Graphite
  option :scheme,
         description: 'Global scheme, text to prepend to .$relative_scheme',
         long: '--scheme SCHEME',
         default: "#{Socket.gethostname}"

  option :file,
         short: '-f file',
         default: 'metrics.yaml'

  def run
    metrics = YAML.load_file(config[:file])

    counters = metrics.keys
    is_ok = true

    flatten = counters.map { |s| "\"#{s}\"" }.join(' ')
    timestamp = Time.now.utc.to_i
    IO.popen("typeperf -sc 1 #{flatten} ") do |io|
      CSV.parse(io.read, headers: true) do |row|
        row.shift
        row.reject{|k, v| !v !! !k}.each do |k, v|
          break if row.to_s.start_with? 'Exiting'

          key = k.split('\\', 4)[3]
          data = metrics.fetch("\\#{key}", nil)
          next unless data

          relative_scheme = data.fetch('scheme', nil)
          relative_scheme ||= key.tr('{}()\- .', '_').tr('\\', '.')

          value = format('%.2f', v.to_f)
          name = [config[:scheme], relative_scheme].join('.')

          output name, value, timestamp

          if data.include? 'min'
            min = data['min']
            if v.to_f < min.to_f
              puts "CHECK ERROR: Value #{v} is higher than #{min} for key #{key}"
              is_ok = false
            end
          end
          if data.include? 'max'
            max = data['max']
            if v.to_f > max.to_f
              puts "CHECK ERROR: Value #{v} is lower than #{max} for key \\#{key}"
              is_ok = false
            end
          end
        end
      end
    end
    if is_ok
      ok
    else
      critical
    end
  end
end
