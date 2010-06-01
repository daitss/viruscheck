require 'rubygems'
require 'bundler'
Bundler.setup

require 'app'

set :env, :production
set :port, 7000
disable :run, :reload

run Sinatra::Application
