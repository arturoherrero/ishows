ENV['GEM_HOME'] = "/home/ishowsap/ruby/gems"
ENV['GEM_PATH'] = "$GEM_HOME:/usr/lib/ruby/gems/1.8"

Gem.clear_paths

require 'lib/server.rb'

run Sinatra::Application
