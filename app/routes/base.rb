require './app/helpers'

module Muraena
  module Routes
    class Base < Sinatra::Application
      configure do
        set :views, 'app/views'

        disable :static

        set :erb, escape_html: true,
                  layout_options: { views: 'app/view/layouts' }
      end

      helpers Helpers::Views,
              Helpers::Decode
    end
  end
end