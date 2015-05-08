require 'json'

# encoding: utf-8
module SensuPluginsPuppet
  # This defines the version of the gem
  module Version
    MAJOR = 0
    MINOR = 1
    PATCH = 0

    VER_STRING = [MAJOR, MINOR, PATCH, 'alpha.2'].compact.join('.')

    NAME   = 'sensu-plugins-puppet'
    BANNER = "#{NAME} v%s"

    module_function

    def version
      format(BANNER, VER_STRING)
    end

    def json_version
      {
        'version' => VER_STRING
      }.to_json
    end
  end
end
