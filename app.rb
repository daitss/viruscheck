#!/usr/bin/env ruby

require 'rubygems'
require 'bundler'
Bundler.setup

require 'sinatra'
require 'uuid'

# TODO have index form for individual use
# TODO support clamdscan
# TODO investigate http://github.com/eagleas/clamav

configure do
  output = %x{clamscan --version 2>&1}
  raise "clamscan not found" unless output.lines.first =~ /ClamAV/
end

post '/' do

  # check the parameters
  error 400, "Missing Data" unless params['data']

  # write to a tempfile
  tf = Tempfile.new 'vc'
  tf.write params['data']
  tf.flush

  # virus scan it
  @output = %x{clamscan #{tf.path} 2>&1}
  tf.close!

  # check its status
  @infected = case $?.exitstatus
              when 0 then false
              when 1 then true
              else raise "problem with virus checker: #{$?.exitstatus}"
              end

  # make an event id
  @event_id = UUID.generate :urn

  erb :results
end
