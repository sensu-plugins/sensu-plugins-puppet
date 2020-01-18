#! /usr/bin/env ruby
#
# check-puppet-ca
#
# DESCRIPTION:
#   Check if the the CA certificate is valid
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
#   check-puppet-ca --ca-file /opt/puppetlabs/puppet/ssl/certs/ca.pem --warning 30 --critical 10
#
# NOTES:
#
# LICENSE:
#   Copyright 2014 Sonian, Inc. and contributors. <support@sensuapp.org>
#   Released under the same terms as Sensu (the MIT license); see LICENSE
#   for details.
#

require 'sensu-plugin/check/cli'
require 'openssl'
require 'time'

class PuppetCa < Sensu::Plugin::Check::CLI
  option :ca_file,
         long:        '--ca-file PATH',
         default:     '/etc/puppetlabs/puppet/ssl/certs/ca.pem',
         description: 'Location of the CA certficate'

  option :warning,
         short:       '-w',
         long:        '--warning DAYS',
         proc:        proc(&:to_i),
         default:     60,
         description: 'Warn EXPIRE days before cert expires'

  option :critical,
         short:       '-c',
         long:        '--critical DAYS',
         proc:        proc(&:to_i),
         default:     30,
         description: 'Critical EXPIRE days before cert expires'

  def run
    unless File.exist?(config[:ca_file])
      unknown("File #{config[:ca_file]} not found")
    end

    now = Time.now.to_i
    cert = OpenSSL::X509::Certificate.new(File.read(config[:ca_file]))
    days_until = ((cert.not_after.to_i - now) / (60 * 60 * 24)).to_i

    if cert.not_before.to_i > now
      critical("Certificate is not valid yet: #{cert.not_before}")
    elsif days_until <= 0
      critical("CA certificate expired #{days_until.abs} days ago.")
    elsif days_until < config[:critical].to_i
      critical("TLS/SSL certificate expires on #{cert.not_after} - #{days_until} days left.")
    elsif days_until < config[:warning].to_i
      warning("TLS/SSL certificate expires on #{cert.not_after} - #{days_until} days left.")
    else
      ok("TLS/SSL certificate expires on #{cert.not_after} - #{days_until} days left.")
    end
  end
end
