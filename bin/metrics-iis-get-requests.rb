#! /usr/bin/env ruby
#
#   iis-get-requests-metrics
#
# DESCRIPTION:
#
# OUTPUT:
#  metric data
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
#  Tested on Windows 2012RC2.
#
# LICENSE:
#   Yohei Kawahara <inokara@gmail.com>
#   Released under the same terms as Sensu (the MIT license); see LICENSE
#   for details.
#

require 'sensu-plugin/metric/cli'
require 'socket'

#
# IIS Get Requests
#
class IisGetRequests < Sensu::Plugin::Metric::CLI::Graphite
  option :scheme,
         description: 'Metric naming scheme, text to prepend to .$parent.$child',
         long: '--scheme SCHEME',
         default: "#{Socket.gethostname}.iis_get_requests"

  option :site,
         short: '-s sitename',
         default: '_Total'

  def run # rubocop:disable all
    io = IO.popen("typeperf -sc 1 \"Web Service(#{config[:site]})\\Get\ Requests\/sec\"")
    get_requests = io.readlines[2].split(',')[1].gsub(/"/, '').to_f

    output [config[:scheme], config[:site]].join('.'), get_requests
    ok
  end
end
