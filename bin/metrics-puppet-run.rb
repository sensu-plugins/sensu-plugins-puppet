#! /usr/bin/env ruby
#
# metrics-puppet-run
#
# DESCRIPTION:
#   Retrieve last puppet run metrics
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
#
# NOTES:
#
# LICENSE:
#   Copyright 2015, Emile Morel (emile@bleuchtang.fr)
#   Released under the same terms as Sensu (the MIT license); see LICENSE
#   for details.
#

require 'sensu-plugin/metric/cli'
require 'yaml'
require 'socket'

class PuppetRun < Sensu::Plugin::Metric::CLI::Graphite
  option :summary_file,
         short:       '-p PATH',
         long:        '--summary-file PATH',
         default:     '/opt/puppetlabs/puppet/cache/state/last_run_summary.yaml',
         description: 'Location of last_run_summary.yaml file'

  option :scheme,
         description: 'Metric naming scheme',
         short: '-s SCHEME',
         long: '--scheme SCHEME',
         default: "#{Socket.gethostname}.puppet"

  def run
    unless File.exist?(config[:summary_file])
      unknown "File #{config[:summary_file]} not found"
    end

    begin
      summary = YAML.load_file(config[:summary_file])
      # print common time
      %w(resources time changes events).each do |i|
        summary[i].each do |key, value|
          output([config[:scheme], i, key].join('.'), value)
        end
      end
    rescue
      unknown "Could not process #{config[:summary_file]}"
    end

    ok
  end
end
