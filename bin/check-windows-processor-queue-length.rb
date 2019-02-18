#! /usr/bin/env ruby
# frozen_string_literal: false

#
#   check-windows-processor-queue-length.rb
#
# DESCRIPTION:
#   This plugin checks the Processor Queue Length
#   It uses Typeperf to get the processor usage.
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
#  Tested on Windows 2012R2.
#
# LICENSE:
#   Andy Royle <ajroyle@gmail.com>
#   Released under the same terms as Sensu (the MIT license); see LICENSE for details.
#
require 'sensu-plugin/check/cli'

class CheckWindowsProcessorQueueLength < Sensu::Plugin::Check::CLI
  option :warning,
         short: '-w WARNING',
         default: 5,
         proc: proc(&:to_i)

  option :critical,
         short: '-c CRITICAL',
         default: 10,
         proc: proc(&:to_i)

  def run
    io = IO.popen('typeperf -sc 1 "system\\processor queue length"')
    cpu_queue = io.readlines[2].split(',')[1].delete('"').to_i
    critical "Processor Queue at at #{cpu_queue}%" if cpu_queue > config[:critical]
    warning "Processor Queue at #{cpu_queue}%" if cpu_queue > config[:warning]
    ok "Processor Queue at #{cpu_queue}%"
  end
end
