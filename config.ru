require 'bundler'
Bundler.require

require_relative 'lib/sse_server'
run Sinatra::Application
