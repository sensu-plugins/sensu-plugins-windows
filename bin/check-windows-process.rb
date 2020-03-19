#! /usr/bin/env ruby
# frozen_string_literal: false

#
#   check-windows-process.rb
#
# DESCRIPTION:
#   This plugin checks whether a User-inputted process is running or not.
#   This checks users tasklist tool to find any process is running or not.
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
#   check-windows-process -p <process substr to match> [ -w <warn age> ]
#
# NOTES:
#
# LICENSE:
#   Copyright 2015 <onetinov@lxrb.com>
#   Released under the same terms as Sensu (the MIT license); see LICENSE for details.
#
require 'optparse'
require 'time'
require 'win32ole'
require 'date'

options = {}
parser = OptionParser.new do |opts|
  opts.banner = 'Usage: check-windows-process.rb [options]'
  opts.on('-h', '--help', 'Display this screen') do
    puts opts
    exit
  end

  options[:procname] = ''
  opts.on('-p', '--processname PROCESS', 'Unique process string to search for.') do |p|
    options[:procname] = p
    if p == ''
      unknown 'Empty string for -p : Expected a string to match against.'
      exit 3
    end
  end

  options[:warn] = nil
  opts.on('-w', '--warning [SECONDS]', 'Minimum process age in secs - Else warn') do |w|
    begin
      options[:warn] = Integer(w)
    rescue ArgumentError
      unknown 'Optional -w needs to be a value in seconds'
      exit 3
    end
  end
end

parser.parse!

if options[:procname] == ''
  warn 'Expected a process to match against.'
  raise OptionParser::MissingArgument
end

wmi = WIN32OLE.connect('winmgmts://')

# Assume Critical error (2) if this loop fails
status = 2
wmi.ExecQuery('select * from win32_process').each do |process|
  next unless process.Name.downcase.include? options[:procname].downcase

  if !options[:warn].nil?
    delta_days = Date.now - Date.parse(process.CreationDate)
    delta_secs = (delta_days * 24 * 60 * 60).to_i
    if delta_secs > options[:warn]
      puts "OK: #{process.Name} running more than #{options[:warn]} seconds."
      status = 0
    else
      puts "WARNING: #{process.Name} only running for #{delta_secs} seconds."
      status = 1
    end
  else
    puts "OK: #{process.Name} running."
    status = 0
  end
end

if status == 2
  puts "Critical: #{options[:procname]} not found in winmgmts:root\\cimv2:Win32_Process"
end

exit status
