#!/usr/bin/env ruby

require 'sinatra'
require 'virus'
require 'daitss/config'

# if we want to rack multiple sinatras up we need to have them separate
module VirusCheckService

  class App < Sinatra::Base
    set :root, File.dirname(__FILE__)

    post '/' do
      Daitss::CONFIG.load ENV['CONFIG']

      # return 400 if there is no body in the request
      error 400, "Missing Data" unless params['data']

      tf = Tempfile.new 'vc'
      tf.write params['data']
      tf.flush
      @path = tf.path
      erb :results
    end

  end

end

VirusCheckService:App.run! if __FILE__ == $0
