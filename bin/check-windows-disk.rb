#! /usr/bin/env ruby
#
#   check-windows-disk.rb
#
# DESCRIPTION:
#   This is mostly copied from the original check-disk.rb plugin and modified
#   to use WMIC.  This is our first attempt at writing a plugin for Windows.
#
# OUTPUT:
#   plain text
#
# PLATFORMS:
#   Windows
#
# DEPENDENCIES:
#   gem: sensu-plugin
#   REQUIRES: ActiveSupport version 4.0 or above.
#
# USAGE:
#
# NOTES:
#   Uses Windows WMIC facility. Warning/critical levels are percentages only.
#
# LICENSE:
#   Copyright 2013 <bp-parks@wiu.edu> and <mr-mencel@wiu.edu>
#   Released under the same terms as Sensu (the MIT license); see LICENSE for details.
#
require 'sensu-plugin/check/cli'

class CheckDisk < Sensu::Plugin::Check::CLI
  option :fstype,
         short: '-t TYPE',
         proc: proc { |a| a.split(',') }

  option :ignoretype,
         short: '-x TYPE',
         proc: proc { |a| a.split(',') }

  option :ignoremnt,
         short: '-i MNT',
         proc: proc { |a| a.split(',') }

  option :ignorelabel,
         short: '-I LABEL_REGEXP',
         proc: proc { |a| Regexp.new(a) }

  option :warn,
         short: '-w PERCENT',
         proc: proc(&:to_i),
         default: 85

  option :crit,
         short: '-c PERCENT',
         proc: proc(&:to_i),
         default: 95

  def initialize
    super
    @crit_fs = []
    @warn_fs = []
  end

  def read_wmic
    `wmic volume where DriveType=3 list brief /format:csv`.split("\n").drop(1).each do |line|
      begin
        # #YELLOW
        _hostname, capacity, type, _fs, _avail, label, mnt = line.split(',') # rubocop:disable Lint/UnderscorePrefixedVariableName
        next if /\S/ !~ line
        next if _avail.nil?
        next if line.include?('System Reserved')
        next if line.include?('\Volume')
        next if config[:fstype] && !config[:fstype].include?(type)
        next if config[:ignoretype] && config[:ignoretype].include?(type)
        next if config[:ignoremnt] && config[:ignoremnt].include?(mnt)
        next if config[:ignorelabel] && config[:ignorelabel].match(label)
      rescue
        unknown "malformed line from df: #{line}"
      end
      # If label value is not set, the drive letter will end up in that column.  Set mnt to label in that case.
      mnt = label if mnt.nil?
      prct_used = (100 * (1 - (_avail.to_f / capacity.to_f)))
      if prct_used >= config[:crit]
        @crit_fs << "#{mnt} #{prct_used.round(2)}"
      elsif prct_used >= config[:warn]
        @warn_fs << "#{mnt} #{prct_used.round(2)}"
      end
    end
  end

  def usage_summary
    (@crit_fs + @warn_fs).join(', ')
  end

  def run
    read_wmic
    critical usage_summary unless @crit_fs.empty?
    warning usage_summary unless @warn_fs.empty?
    ok "All disk usage under #{config[:warn]}%"
  end
end
