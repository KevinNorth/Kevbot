module Config
	require 'yaml'

	def self.load_config
		return YAML.load_file('config.yaml')
	end
end