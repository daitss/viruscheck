require 'rubygems'
require 'bundler'
Bundler.setup

require 'app'

set :env, :production

enable :clamd

disable :run, :reload

run Sinatra::Application
