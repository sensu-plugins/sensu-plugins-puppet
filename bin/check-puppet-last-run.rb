#! /usr/bin/env ruby
#
# check-puppet-last-run
#
# DESCRIPTION:
#   Check the last time puppet was last run
#
# OUTPUT:
#   plain-text
#
# PLATFORMS:
#   Linux
#
# DEPENDENCIES:
#   gem: sensu-plugin
#
# USAGE:
#   Critical if last run is greater than
#
#   check-puppet-last-run --summary-file /opt/puppetlabs/puppet/cache/state/last_run_summary.yaml --warn-age 3600 --crit-age 7200
#
# NOTES:
#
# LICENSE:
#   Copyright 2014 Sonian, Inc. and contributors. <support@sensuapp.org>
#   Released under the same terms as Sensu (the MIT license); see LICENSE
#   for details.
#

require 'sensu-plugin/check/cli'
require 'yaml'
require 'time'

class PuppetLastRun < Sensu::Plugin::Check::CLI
  option :summary_file,
         short:       '-s PATH',
         long:        '--summary-file PATH',
         default:     '/opt/puppetlabs/puppet/cache/state/last_run_summary.yaml',
         description: 'Location of last_run_summary.yaml file'

  option :warn_age,
         short:       '-w N',
         long:        '--warn-age SECONDS',
         default:     3600,
         proc:        proc(&:to_i),
         description: 'Age in seconds to be a warning'

  option :crit_age,
         short:       '-c N',
         long:        '--crit-age SECONDS',
         default:     7200,
         proc:        proc(&:to_i),
         description: 'Age in seconds to be a critical'

  def run
    unless File.exist?(config[:summary_file])
      unknown "File #{config[:summary_file]} not found"
    end

    @now = Time.now.to_i

    begin
      summary = YAML.load_file(config[:summary_file])
      @last_run = summary['time']['last_run'].to_i
    rescue
      unknown "Could not process #{config[:summary_file]}"
    end

    @message = "Puppet last run #{@now - @last_run} seconds ago"

    if @now - @last_run > config[:crit_age]
      critical @message
    elsif @now - @last_run > config[:warn_age]
      warning @message
    else
      ok @message
    end
  end
end
