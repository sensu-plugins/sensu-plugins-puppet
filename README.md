## Sensu-Plugins-puppet

[![Sensu Bonsai Asset](https://img.shields.io/badge/Bonsai-Download%20Me-brightgreen.svg?colorB=89C967&logo=sensu)](https://bonsai.sensu.io/assets/sensu-plugins/sensu-plugins-puppet)
[![Build Status](https://travis-ci.org/sensu-plugins/sensu-plugins-puppet.svg?branch=master)](https://travis-ci.org/sensu-plugins/sensu-plugins-puppet)
[![Gem Version](https://badge.fury.io/rb/sensu-plugins-puppet.svg)](http://badge.fury.io/rb/sensu-plugins-puppet)
[![Code Climate](https://codeclimate.com/github/sensu-plugins/sensu-plugins-puppet/badges/gpa.svg)](https://codeclimate.com/github/sensu-plugins/sensu-plugins-puppet)
[![Test Coverage](https://codeclimate.com/github/sensu-plugins/sensu-plugins-puppet/badges/coverage.svg)](https://codeclimate.com/github/sensu-plugins/sensu-plugins-puppet)
[![Dependency Status](https://gemnasium.com/sensu-plugins/sensu-plugins-puppet.svg)](https://gemnasium.com/sensu-plugins/sensu-plugins-puppet)

## Functionality

### check-puppet-last-run.rb
Validates Puppet last run. Alerts if last Puppet run was later than threshold or it has errors

```
Usage: ./bin/check-puppet-last-run.rb (options)
    -a, --agent-disabled-file PATH   Path to agent disabled lock file
    -c, --crit-age SECONDS           Age in seconds to be a critical
    -C, --crit-age-disabled SECONDS  Age in seconds to crit when agent is disabled
    -d, --disabled-age-limits        Consider disabled age limits, otherwise use main limits
    -i, --ignore-failures            Ignore Puppet failures
    -r, --report-restart-failures    Raise alerts if restart failures have happened
    -s, --summary-file PATH          Location of last_run_summary.yaml file
    -w, --warn-age SECONDS           Age in seconds to be a warning
    -W, --warn-age-disabled SECONDS  Age in seconds to warn when agent is disabled

```

### check-puppet-errors.rb
Validates only Puppet run errors regardless of the execution time

```
Usage: ./bin/check-puppet-errors.rb (options)
    -a, --agent-disabled-file PATH   Path to agent disabled lock file
    -s, --summary-file PATH          Location of last_run_summary.yaml file
```

### metrics-puppet-run.rb
Provides metrics from Puppet last run in graphite format. 

```
Usage: ./bin/metrics-puppet-run.rb (options)
    -s, --scheme SCHEME              Metric naming scheme
    -p, --summary-file PATH          Location of last_run_summary.yaml file
```

## Files

* /bin/checkpuppet-last-run.rb
* /bin/metrics-puppet-run.rb
* /bin/check-puppet-errors.rb


## Installation Options
### Asset registration

Assets are the best way to make use of this plugin in Sensu Go. If you're not using an asset, please consider doing so! If you're using sensuctl 5.13 or later, you can use the following command to add the latest version of this asset: 

`sensuctl asset add sensu-plugins/sensu-plugins-puppet`

If you're using an earlier version of sensuctl, you can download the asset definition from [this project's Bonsai Asset Index page](https://bonsai.sensu.io/assets/sensu-plugins/sensu-plugins-puupet).


### Gem Installation

[Installation and Setup](http://sensu-plugins.io/docs/installation_instructions.html)

## Notes

As the sensu user doesn't have read access to `/opt/puppetlabs/puppet/cache/state/last_run_summary.yaml` it is necessary to create an appropriate entry in `/etc/sudoers.d` and call `check-puppet-last-run.rb` or `metrics-puppet-run.rb` using `sudo`.
