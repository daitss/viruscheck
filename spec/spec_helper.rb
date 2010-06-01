require "rubygems"
require "bundler"
Bundler.setup :default, :test

require File.join(File.dirname(__FILE__), '..', 'app.rb')
require 'webrat'
require 'rack/test'
require 'libxml'

set :environment, :test

Spec::Runner.configure do |config|
  config.include Rack::Test::Methods
  config.include Webrat::Methods
  config.include Webrat::Matchers

  def app
    Sinatra::Application
  end

end

Spec::Matchers.define :have_event do |options|

  match do |res|
    doc = LibXML::XML::Document.string res.body
    xpath = %Q{//P:event[ P:eventType = '#{options[:type]}' and
                          P:eventOutcomeInformation/P:eventOutcome = '#{options[:outcome]}' ]}
                          doc.find_first xpath, 'P' => 'info:lc/xmlns/premis-v2'
  end

  failure_message_for_should do |res|
    "expected response to have a premis event: #{options.inspect}"
  end

  failure_message_for_should_not do |res|
    "expected response to not have a premis event: #{options.inspect}"
  end

end
