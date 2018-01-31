#Change Log
This project adheres to [Semantic Versioning](http://semver.org/).

This CHANGELOG follows the format listed at [Keep A Changelog](http://keepachangelog.com/)

## [Unreleased]
### Security
- updated `rubocop` dependency to `~> 0.51.0` per: https://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2017-8418. (@jaredledvina)

### Breaking Changes
- in order to bring in new rubocop dependency we need to drop ruby 2.0 support as it is EOL and aligns with out support policy. (@jaredledvina)

## [1.3.0] - 2017-11-09
### Added
- Testing for Ruby 2.4.1
- `check-puppet-errors.rb`: Added check for Puppet failures (@grem11n)
- `check-puppet-last-run.rb`: Added option for ignoring Puppet failure (@grem11n)

## [1.2.0] - 2017-05-30
### Added
- `check-puppet-last-run.rb`: Added option for reporting failed restarts (@antonidabek)

## [1.1.0] - 2017-01-30
### Added
- `check-puppet-last-run.rb`: Added critical alerting on failures during summary file processing (@grem11n)

### Fixed
- `check-puppet-last-run.rb`: Corrected failure count hash key (@eahola)

## [1.0.0] - 2016-06-21
### Changed
- check-puppet-last-run.rb: Added a formatter method to display time in a more human friendly format. (d m s) ago
- check-puppet-last-run.rb: if the agent is disabled via lock file, display reason (if available)
- Loosened dependency on sensu-plugin from `= 1.2.0` to `~> 1.2.0`
- Updated Rubocop to 0.40, applied auto-correct
- check-puppet-last-run.rb: now returns critical when errors are found in the puppet run

### Removed
- Remove Ruby 1.9.3 support; add Ruby 2.2.0 and 2.3.0 support to test matrix.

## [0.0.2] - 2015-07-14
### Changed
- updated sensu-plugin gem to 1.2.0

## [0.0.1] - 2015-07-04
### Added
- initial release

[Unreleased]: https://github.com/sensu-plugins/sensu-plugins-puppet/compare/1.3.0...HEAD
[1.3.0]: https://github.com/sensu-plugins/sensu-plugins-puppet/compare/1.2.0...1.3.0
[1.2.0]: https://github.com/sensu-plugins/sensu-plugins-puppet/compare/1.1.0...1.2.0
[1.1.0]: https://github.com/sensu-plugins/sensu-plugins-puppet/compare/1.0.0...1.1.0
[1.0.0]: https://github.com/sensu-plugins/sensu-plugins-puppet/compare/0.0.2...1.0.0
[0.0.2]: https://github.com/sensu-plugins/sensu-plugins-puppet/compare/0.0.1...0.0.2
