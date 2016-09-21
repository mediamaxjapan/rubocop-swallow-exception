require 'rubocop/config_loader'

module RuboCop
  module SwallowException
    module Inject

      DEFAULT_FILE = File.expand_path('../../../../config/default.yml', __FILE__)

      def self.defaults!
        default = ConfigLoader.load_file(DEFAULT_FILE)
        config = ConfigLoader.merge_with_default(default, DEFAULT_FILE)
        ConfigLoader.instance_variable_set(:@default_configuration, config)
      end

    end
  end
end
