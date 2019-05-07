module Muraena
  module Routes
    class Start < Routes::Base
      # Muraena initialization
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
              Muraena::App.settings.cache.write('paths', paths)
              Muraena::App.settings.cache.write(k,v)
            end
          end
          return_message[:status] = 'setup_data_accepted'
        end
        return_message[:jdata] = jdata
        return_message.to_json
      end
    end
  end
end