require 'yaml'
require 'base64'
require 'erb'

# COMPOSE_PATH = 'compose/'.freeze
CONFIG_PATH = 'config/app.yml'.freeze

@config = YAML.load_file(CONFIG_PATH)

Dir.glob('lib/tasks/*.rake').each do |task|
  load task
end