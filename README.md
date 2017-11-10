## Sensu-Plugins-puppet

[![Build Status](https://travis-ci.org/sensu-plugins/sensu-plugins-puppet.svg?branch=master)](https://travis-ci.org/sensu-plugins/sensu-plugins-puppet)
[![Gem Version](https://badge.fury.io/rb/sensu-plugins-puppet.svg)](http://badge.fury.io/rb/sensu-plugins-puppet)
[![Code Climate](https://codeclimate.com/github/sensu-plugins/sensu-plugins-puppet/badges/gpa.svg)](https://codeclimate.com/github/sensu-plugins/sensu-plugins-puppet)
[![Test Coverage](https://codeclimate.com/github/sensu-plugins/sensu-plugins-puppet/badges/coverage.svg)](https://codeclimate.com/github/sensu-plugins/sensu-plugins-puppet)
[![Dependency Status](https://gemnasium.com/sensu-plugins/sensu-plugins-puppet.svg)](https://gemnasium.com/sensu-plugins/sensu-plugins-puppet)

## Functionality

### check-puppet-last-run.rb
Validates Puppet last run. Alerts if last Puppet run was later than threshold or it has errors

### check-puppet-errors.rb
Validates only Puppet run errors regardless of the execution time

## Files

* /bin/checkpuppet-last-run.rb
* /bin/metrics-puppet-run.rb
* /bin/check-puppet-errors.rb

## Installation

[Installation and Setup](http://sensu-plugins.io/docs/installation_instructions.html)

## Notes

As the sensu user doesn't have read access to `/opt/puppetlabs/puppet/cache/state/last_run_summary.yaml` it is necessary to create an appropriate entry in `/etc/sudoers.d` and call `check-puppet-last-run.rb` or `metrics-puppet-run.rb` using `sudo`.
