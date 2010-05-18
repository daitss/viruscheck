require 'rack/test'
require 'spec'
require 'sinatra'
require 'daitss/config'
require 'libxml'
require 'xmlns'

raise "CONFIG not set" unless ENV['CONFIG']
Daitss::CONFIG.load ENV['CONFIG']

Spec::Runner.configure do |conf|
  conf.include Rack::Test::Methods
end

set :environment, :test

def app
  VirusCheckService::App
end

Spec::Matchers.define :have_event do |options|

  match do |res|
    doc = LibXML::XML::Document.string res.body
    xpath = %Q{//P:event[ P:eventType = '#{options[:type]}' and
                          P:eventOutcomeInformation/P:eventOutcome = '#{options[:outcome]}' ]}
                          doc.find_first xpath, NS_PREFIX
  end

  failure_message_for_should do |res|
    "expected response to have a premis event: #{options.inspect}"
  end

  failure_message_for_should_not do |res|
    "expected response to not have a premis event: #{options.inspect}"
  end

end
