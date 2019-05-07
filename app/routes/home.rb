module Muraena
  module Routes
    class Home < Routes::Base
      get '/' do
        index = Muraena::App.settings.cache.read('index')
        unless index.nil?
          erb decoder(Muraena::App.settings.cache.read('index'))
        else
          redirect '/hello'
        end
      end

      get '/hello' do
        Muraena::App.settings.cache.fetch('hello') { "Hello ! Welcome to #{request.host} !" }
      end

      get '/:url' do
        paths = Muraena::App.settings.cache.read('paths')
        if paths && paths.include?(params[:url])
          erb decoder(Muraena::App.settings.cache.read(params[:url]))
        else
          pass
        end
      end
    end
  end
end
