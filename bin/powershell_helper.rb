#! /usr/bin/env ruby
#
#   powershell_helper.rb
#
# DESCRIPTION:
#   This is meant to execute powershell in the bin/powershell deirectory
#   so we don't have to copy the code out of the GEM. This is meant only as a
#   wrapper.
#
# OUTPUT:
#   N/A
#
# PLATFORMS:
#   Windows
#
# DEPENDENCIES:
#   None
#
# USAGE:
#   C:\opt\sensu\embedded\bin\ruby C:\opt\sensu\embedded\bin\powershell_helper <poweshell-script> ARGS
#
# NOTES:
#
# LICENSE:
#   Copyright 2018 <dasecretzofwar@gmail.com>
#   Released under the same terms as Sensu (the MIT license); see LICENSE for details.
#

if ARGV.empty?
  puts 'You must specify arguments for powershell file'
  exit 2
end

powershell_dir = File.expand_path('./powershell', File.dirname(__FILE__))
command = "Powershell.exe -NonInteractive -NoProfile -ExecutionPolicy Bypass -NoLogo -File #{File.expand_path(ARGV.join(' '), powershell_dir)}"
exec command
