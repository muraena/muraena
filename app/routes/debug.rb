module Muraena
  module Routes
    class Debug < Routes::Base
      post '/debug/echo' do
        request.body.rewind
        data = JSON.parse request.body.read
        "#{data}!"
      end

      get '/set_hello/:data' do
        Muraena::App.settings.cache.write('hello', params[:data])
        { status: 'recorder' }.to_json
      end

      get '/debug/reset' do
        Muraena::App.settings.cache.clear
        return_message = { status: "cache_cleared" }
        return_message.to_json
      end

      get '/debug/read_by_cache_key/:key' do
        value = Muraena::App.settings.cache.fetch(params[:key])
        "#{params[:key]} => #{value}"
      end

      get '/debug/remove_by_cache_key/:key' do
        value = Muraena::App.settings.cache.delete(params[:key])
        "#{params[:key]} => #{value}"
      end

      get '/debug/paths' do
        @paths = Muraena::App.settings.cache.read('paths') || []
        erb :paths
      end
    end
  end
end