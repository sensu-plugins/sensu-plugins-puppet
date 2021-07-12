# frozen_string_literal: false

require 'sensu-plugins-puppet/version'

module SensuPluginsPuppet
  SUMMARY_FILE        = "#{Gem.win_platform? ? 'C:/ProgramData/PuppetLabs' : '/opt/puppetlabs'}/puppet/cache/state/last_run_summary.yaml".freeze
  REPORT_FILE         = "#{Gem.win_platform? ? 'C:/ProgramData/PuppetLabs' : '/opt/puppetlabs'}/puppet/cache/state/last_run_report.yaml".freeze
  AGENT_DISABLED_FILE = "#{Gem.win_platform? ? 'C:/ProgramData/PuppetLabs' : '/opt/puppetlabs'}/puppet/cache/state/agent_disabled.lock".freeze
end
