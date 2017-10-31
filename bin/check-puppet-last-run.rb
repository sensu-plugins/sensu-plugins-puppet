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
require 'json'
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

  option :agent_disabled_file,
         short:       '-a PATH',
         long:        '--agent-disabled-file PATH',
         default:     '/opt/puppetlabs/puppet/cache/state/agent_disabled.lock',
         description: 'Path to agent disabled lock file'

  option :report_restart_failures,
         short:       '-r',
         long:        '--report-restart-failures',
         boolean:     true,
         default:     false,
         description: 'Raise alerts if restart failures have happened'

  option :ignore_failures,
         short:       '-i',
         long:        '--ignore-failures',
         boolean:     true,
         default:     false,
         description: 'Ignore Puppet failures'

  def run
    unless File.exist?(config[:summary_file])
      unknown "File #{config[:summary_file]} not found"
    end

    @now = Time.now.to_i

    begin
      summary = YAML.load_file(config[:summary_file])
      if summary['time']
        @last_run = summary['time']['last_run'].to_i
      else
        critical "#{config[:summary_file]} is missing information about the last run timestamp"
      end
      unless config[:ignore_failures]
        if summary['events']
          @failures = summary['events']['failure'].to_i
        else
          critical "#{config[:summary_file]} is missing information about the events"
        end
        @restart_failures = if config[:report_restart_failures] && summary['resources']
                              summary['resources']['failed_to_restart'].to_i
                            else
                              0
                            end
      end
    rescue
      unknown "Could not process #{config[:summary_file]}"
    end

    @message = "Puppet last run #{formatted_duration(@now - @last_run)} ago"

    begin
      disabled_message = JSON.parse(File.read(config[:agent_disabled_file]))['disabled_message']
      @message += " (disabled reason: #{disabled_message})"
    rescue # rubocop:disable HandleExceptions
      # fail silently
    end

    if @failures > 0
      @message += " with #{@failures} failures"
    end

    if @restart_failures > 0
      @message += " with #{@restart_failures} restart failures"
    end

    if @now - @last_run > config[:crit_age] || @failures > 0 || @restart_failures > 0
      critical @message
    elsif @now - @last_run > config[:warn_age]
      warning @message
    else
      ok @message
    end
  end

  def formatted_duration(total_seconds)
    hours = total_seconds / (60 * 60)
    minutes = (total_seconds / 60) % 60
    seconds = total_seconds % 60

    if hours <= 0 && minutes > 0
      "#{minutes}m #{seconds}s"
    elsif minutes <= 0
      "#{seconds}s"
    else
      "#{hours}h #{minutes}m #{seconds}s"
    end
  end
end
