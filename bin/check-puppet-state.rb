#! /usr/bin/env ruby
# frozen_string_literal: true

#
# check-puppet-state
#
# DESCRIPTION:
#   Check consecutive puppet runs for changes
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
#   Critical if number of changes for last 3 puppet runs is greater than
#
#   check-puppet-state --summary-file /opt/puppetlabs/puppet/cache/state/last_run_summary.yaml --crit-changes 2
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

class PuppetLastRun < Sensu::Plugin::Check::CLI
  DEFAULT_CACHE_FILE = '/tmp/sensu-plugins-puppet-cache.yml'

  option :summary_file,
         short:       '-s PATH',
         long:        '--summary-file PATH',
         default:     '/opt/puppetlabs/puppet/cache/state/last_run_summary.yaml',
         description: 'Location of last_run_summary.yaml file'

  option :agent_disabled_file,
         short:       '-a PATH',
         long:        '--agent-disabled-file PATH',
         default:     '/opt/puppetlabs/puppet/cache/state/agent_disabled.lock',
         description: 'Path to agent disabled lock file'

  option :runs,
         short:       '-r',
         long:        '--runs',
         default:     3,
         description: 'Consecutive runs to check'

  option :warning_changes,
         short:       '-w',
         long:        '--warn-changes',
         default:     0,
         description: 'Maximal changes allowed during runs for warning result'

  option :critical_changes,
         short:       '-c',
         long:        '--crit-changes',
         default:     0,
         description: 'Maximal changes allowed during runs for critical result'

  def run
    unless File.exist?(config[:summary_file])
      unknown("File #{config[:summary_file]} not found")
    end

    if File.exist?(config[:agent_disabled_file])
      ok('Puppet agent disabled')
    end

    timestamp, summary = load_summary

    cache[timestamp] = summary

    write_cache_file

    if cache.length < config[:runs]
      ok("Number of cached puppet runs (#{cache.length}) are less than required minimum (#{config[:runs]})")
    end

    changes = cache.keys.sort.reverse[0..(config[:runs] - 1)].map { |k| cache[k]['changes']['total'] }

    if changes.all? { |c| c.positive? && c >= config[:critical_changes] }
      critical("Last #{config[:runs]} puppet runs contain more than (#{config[:critical_changes]}) changes")
    elsif changes.all? { |c| c.positive? && c >= config[:warning_changes] }
      warning("Last #{config[:runs]} puppet runs contain more than (#{config[:warning_changes]}) changes")
    elsif changes.all?(&:zero?)
      ok("Last #{config[:runs]} puppet runs contain no changes")
    else
      ok("Last #{config[:runs]} puppet runs contain less than (#{config[:warning_changes]}) changes")
    end
  end

  private

  def load_summary
    summary = YAML.load_file(config[:summary_file])

    [summary['time']['last_run'], summary]
  rescue StandardError
    unknown("Could not process #{config[:summary_file]}")
  end

  def cache
    @cache ||= YAML.load_file(DEFAULT_CACHE_FILE)
  rescue StandardError
    @cache ||= {}
  end

  def write_cache_file
    # cleanup old entries from cache
    old_keys = cache.keys.sort.reverse[(config[:runs] * 2)..-1] || []
    old_keys.each { |k| cache.delete(k) }

    File.open(DEFAULT_CACHE_FILE, 'w') { |f| f.write(cache.to_yaml) }
  end
end
