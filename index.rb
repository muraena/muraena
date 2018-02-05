require 'sinatra'
require 'sinatra/base'
require 'redis-sinatra'
require 'json'
require 'zlib'
require 'base64'

class Muraena < Sinatra::Base
  register Sinatra::Cache

  helpers do
    def link_to url_fragment, mode = :path_only
      case mode
        when :path_only
          base = request.script_name
        when :full_url
          if (request.scheme == 'http' && request.port == 80 ||
              request.scheme == 'https' && request.port == 443)
            port = ""
          else
            port = ":#{request.port}"
          end
          base = "#{request.scheme}://#{request.host}#{port}#{request.script_name}"
        else
          raise "Unknown script_url mode #{mode}"
      end
      "#{base}#{url_fragment}"
    end

    def decoder(encoded_data)
      Zlib::Inflate.inflate(Base64.decode64(encoded_data))
    rescue
      encoded_data
    end
  end

  get '/' do
    index = settings.cache.read('index')
    unless index.nil?
      erb decoder(settings.cache.read('index'))
    else
      redirect '/hello'
    end
  end

  get '/hello' do
    settings.cache.fetch('hello') { "Hello ! Welcome to #{request.host} !" }
  end

  get '/set_hello/:data' do
    settings.cache.write('hello', params[:data])
    { status: 'recorder' }.to_json
  end

  get '/paths' do
    @paths = settings.cache.read('paths') || []
    erb :paths
  end

  get '/:url' do
    paths = settings.cache.read('paths')
    if paths.include?(params[:url])
      erb decoder(settings.cache.read(params[:url]))
    else
      pass
    end
  end

  # Initialization

  post '/start' do
    return_message = { status: 'wrong_setup_data' }
    request.body.rewind
    jdata = JSON.parse(request.body.read, :symbolize_names => true)
    unless jdata.nil?
      core = jdata[:core]
      if core.is_a?(Array)
        paths = []
        core.each do |k,v|
          paths << k
          settings.cache.write('paths', paths)
          settings.cache.write(k,v)
        end
      end
      return_message[:status] = 'setup_data_accepted'
    end
    return_message[:jdata] = jdata
    return_message.to_json
  end

  # Debug section

  post '/echo' do
    request.body.rewind
    data = JSON.parse request.body.read
    "#{data}!"
  end

  get '/reset' do
    settings.cache.clear
    return_message = { status: "cache_cleared" }
    return_message.to_json
  end

  get '/read_by_cache_key/:key' do
    value = settings.cache.fetch(params[:key])
    "#{params[:key]} => #{value}"
  end

  get '/remove_by_cache_key/:key' do
    value = settings.cache.delete(params[:key])
    "#{params[:key]} => #{value}"
  end
end