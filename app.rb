#!/usr/bin/env ruby

require 'rubygems'
require 'bundler/setup'
require 'ruby-debug'

require 'sinatra'
require 'datyl/logger'
require 'datyl/config'
require 'uuid'
require 'fileutils'

include Datyl

# TODO have index form for individual use
# TODO investigate http://github.com/eagleas/clamav

def get_config
  raise "No DAITSS_CONFIG environment variable has been set, so there's no configuration file to read"             unless ENV['DAITSS_CONFIG']
  raise "The DAITSS_CONFIG environment variable points to a non-existant file, (#{ENV['DAITSS_CONFIG']})"          unless File.exists? ENV['DAITSS_CONFIG']
  raise "The DAITSS_CONFIG environment variable points to a directory instead of a file (#{ENV['DAITSS_CONFIG']})"     if File.directory? ENV['DAITSS_CONFIG']
  raise "The DAITSS_CONFIG environment variable points to an unreadable file (#{ENV['DAITSS_CONFIG']})"            unless File.readable? ENV['DAITSS_CONFIG']

  Datyl::Config.new(ENV['DAITSS_CONFIG'], :defaults, ENV['VIRTUAL_HOSTNAME'])
end

configure do |s|
  config = get_config

  disable :logging        # Stop CommonLogger from logging to STDERR; we'll set it up ourselves.

  disable :dump_errors    # Normally set to true in 'classic' style apps (of which this is one) regardless of :environment; it adds a backtrace to STDERR on all raised errors (even those we properly handle). Not so good.

  set :environment,  :production  # Get some exceptional defaults.

  set :raise_errors, false        # Handle our own exceptions.
  
  set :clamd, config.clamd

  Logger.setup('VirusCheck', ENV['VIRTUAL_HOSTNAME'])

  if not (config.log_syslog_facility or config.log_filename)
    Logger.stderr # log to STDERR
  end

  Logger.facility = config.log_syslog_facility if config.log_syslog_facility
  Logger.filename = config.log_filename if config.log_filename

  Logger.info "Starting up viruscheck service"
  Logger.info "Using temp directory #{ENV['TMPDIR']}"

  use Rack::CommonLogger, Logger.new(:info, 'Rack:')
end #of configure

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


end # of helpers

error do
  e = @env['sinatra.error']

  request.body.rewind if request.body.respond_to?('rewind') # work around for verbose passenger warning

  Logger.err "Caught exception #{e.class}: '#{e.message}'; backtrace follows", @env
  e.backtrace.each { |line| Logger.err line, @env }

  halt 500, { 'Content-Type' => 'text/plain' }, e.message + "\n"
end 

not_found do
  request.body.rewind if request.body.respond_to?(:rewind)

  content_type 'text/plain'  
  "Not Found\n"
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

get '/status' do
  [ 200, {'Content-Type'  => 'application/xml'}, "<status/>\n" ]
end

