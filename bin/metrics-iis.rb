#! /usr/bin/env ruby
#
#   metrics-iis.rb
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
require 'csv'

#
# IIS Metrics
#
class IisMetric < Sensu::Plugin::Metric::CLI::Graphite
  option :scheme,
         description: 'Metric naming scheme, text to prepend to .$parent.$child',
         long: '--scheme SCHEME',
         default: "#{Socket.gethostname}.iis"

  option :site,
         short: '-s sitename',
         default: '_Total'

  option :metric,
         short: '-m metric',
         default: '*'

  def run
    site = config[:site]
    metric = config[:metric]
    timestamp = Time.now.utc.to_i
    IO.popen("typeperf -sc 1 \"Web Service(#{site})\\#{metric}\" ") do |io|
      CSV.parse(io.read, headers: true) do |row|
        row.each do |k, v|
          next if k == row.headers[0]
          next unless v && k
          break if v.start_with? 'Exiting'

          path = k.split('\\')
          service = path[3]
          metric = path[4]
          next unless service && metric

          ifz_name = service[12, service.length - 13].gsub('.', ' ')
          value = format('%.2f', v.to_f)
          name = [config[:scheme], ifz_name, metric].join('.').gsub(' ', '_').tr('{}', '')

          output name, value, timestamp
        end
      end
    end
    ok
  end
end