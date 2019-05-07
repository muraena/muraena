require 'rubygems'
require 'bundler'

Bundler.require

require 'sinatra/base'
require 'redis-sinatra'
require 'json'
require 'zlib'
require 'base64'

require './app/routes'
require './app/helpers'

module Muraena
  class App < Sinatra::Base
    register Sinatra::Cache

    configure do
      disable :method_override
      disable :static

      set :sessions,
          http_only: true,
          secure: production?,
          expire_after: 31557600 # 1 year
    end

    use Routes::Home
    use Routes::Debug
    use Routes::Start

    helpers Helpers::Views,
            Helpers::Decode
  end
end
