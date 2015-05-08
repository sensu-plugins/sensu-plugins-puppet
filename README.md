## Sensu-Plugins-puppet

[![Build Status](https://travis-ci.org/sensu-plugins/sensu-plugins-puppet.svg?branch=master)](https://travis-ci.org/sensu-plugins/sensu-plugins-puppet)
[![Gem Version](https://badge.fury.io/rb/sensu-plugins-puppet.svg)](http://badge.fury.io/rb/sensu-plugins-puppet)
[![Code Climate](https://codeclimate.com/github/sensu-plugins/sensu-plugins-puppet/badges/gpa.svg)](https://codeclimate.com/github/sensu-plugins/sensu-plugins-puppet)
[![Test Coverage](https://codeclimate.com/github/sensu-plugins/sensu-plugins-puppet/badges/coverage.svg)](https://codeclimate.com/github/sensu-plugins/sensu-plugins-puppet)
[![Dependency Status](https://gemnasium.com/sensu-plugins/sensu-plugins-puppet.svg)](https://gemnasium.com/sensu-plugins/sensu-plugins-puppet)
[ ![Codeship Status for sensu-plugins/sensu-plugins-puppet](https://codeship.com/projects/2a9c6e70-d4b4-0132-67ee-4e043b6b23b5/status?branch=master)](https://codeship.com/projects/77866)

## Functionality

**check-puppet-last-run.rb**

## Files

* /bin/checkpuppet-last-run.rb

## Installation

Add the public key (if you haven’t already) as a trusted certificate

```
gem cert --add <(curl -Ls https://raw.githubusercontent.com/sensu-plugins/sensu-plugins.github.io/master/certs/sensu-plugins.pem)
gem install <gem> -P MediumSecurity
```

You can also download the key from /certs/ within each repository.

#### Rubygems

`gem install sensu-plugins-puppet`

#### Bundler

Add *sensu-plugins-puppet* to your Gemfile and run `bundle install` or `bundle update`

#### Chef

Using the Sensu **sensu_gem** LWRP
```
sensu_gem 'sensu-plugins-puppet' do
  options('--prerelease')
  version '0.1.0'
end
```

Using the Chef **gem_package** resource
```
gem_package 'sensu-plugins-puppet' do
  options('--prerelease')
  version '0.1.0'
end
```

## Notes
