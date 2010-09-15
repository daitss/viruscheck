#!/usr/bin/env ruby

require 'rubygems'
require 'bundler'
Bundler.setup
require 'ruby-debug'

require 'sinatra'

require 'uuid'
require 'fileutils'

# TODO have index form for individual use
# TODO investigate http://github.com/eagleas/clamav

helpers do

  def clambin
    settings.clamd ? 'clamdscan' : 'clamscan'
  end

  def clamscan data

    # write to a tempfile
    tf = params['data'][:tempfile]

    # needed for clamav to read the file as a different user
    FileUtils.chmod 0644, tf.path

    # virus scan it
    @output = `#{clambin} #{tf.path} 2>&1`

    # check its status
    @infected = case $?.exitstatus
                when 0 then false
                when 1 then true
                else raise <<-MESSAGE
problem with #{clambin} (#{$?.exitstatus}):
                  #{@output}
                  MESSAGE
                end
  end

end


configure do |s|
  disable :clamd
end

get '/' do
  erb :index
end

post '/' do
  # check the parameters
  error 400, "Missing Data" unless params['data']
  error 400, "Missing Data" if params['data'].empty?
  clamscan params['data']

  # make an event id
  @event_id = UUID.generate :urn

  erb :results
end
