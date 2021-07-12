#! /usr/bin/env ruby
# frozen_string_literal: true

#
# check-puppet-errors
#
# DESCRIPTION:
#   Check if Puppet ran with errors
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
#   Critical if last run had errors
#
#   check-puppet-errors --summary-file /opt/puppetlabs/puppet/cache/state/last_run_summary.yaml
#
# NOTES:
#
# LICENSE:
#   Copyright 2014 Sonian, Inc. and contributors. <support@sensuapp.org>
#   Released under the same terms as Sensu (the MIT license); see LICENSE
#   for details.
#

require 'sensu-plugins-puppet'
require 'sensu-plugin/check/cli'
require 'yaml'
require 'json'
require 'time'

class PuppetErrors < Sensu::Plugin::Check::CLI
  option :summary_file,
         short: '-s PATH',
         long: '--summary-file PATH',
         default: SensuPluginsPuppet::SUMMARY_FILE,
         description: 'Location of last_run_summary.yaml file'

  option :agent_disabled_file,
         short: '-a PATH',
         long: '--agent-disabled-file PATH',
         default: SensuPluginsPuppet::AGENT_DISABLED_FILE,
         description: 'Path to agent disabled lock file'
         
  option :report_file,
         short: '-r PATH',
         long: '--report-file PATH',
         default: SensuPluginsPuppet::REPORT_FILE,
         description: 'Location of last_run_report.yaml file'
  
  def run
    unless File.exist?(config[:summary_file])
      unknown "File #{config[:summary_file]} not found"
    end
    unless File.exist?(config[:report_file])
      unknown "File #{config[:report_file]} not found"
    end

    begin
      summary = YAML.load_file(config[:summary_file])
      if summary['events']
        @failures = summary['events']['failure'].to_i
      else
        critical "#{config[:summary_file]} is missing information about the events"
      end
    rescue StandardError
      unknown "Could not process #{config[:summary_file]}"
    end

    begin
      %["sudo /usr/bin/head -n 13 #{config[:report_file]}"].split('\n').each { |line| 
        if line.eql? 'status: failed'
          critical 'Last Puppet run reports status: failed'
        end
        if line.eql? 'transaction_completed: false'
          critical 'Last Puppet run reports transaction_completed: false'
        end
      }
    rescue StandardError
      unknown "Could not process #{config[:report_file]}"
    end

    @message = 'Puppet run'

    if File.exist?(config[:agent_disabled_file])
      begin
        disabled_message = JSON.parse(File.read(config[:agent_disabled_file]))['disabled_message']
        @message += " (disabled reason: #{disabled_message})"
      rescue StandardError => e
        unknown "Could not get disabled message. Reason: #{e.message}"
      end
    end

    if @failures > 0 # rubocop:disable Style/NumericPredicate
      @message += " had #{@failures} failures"
      critical @message
    else
      @message += ' was successful'
      ok @message
    end
  end
end
