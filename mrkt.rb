require 'java'
require 'bundler/setup'

Bundler.require

require 'mrkt/simulation'

CONFIG = YAML.load_file 'config.yml'

Simulation.run
