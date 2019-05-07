module Muraena
  module Helpers
    module Decode
      def decoder(encoded_data)
        Zlib::Inflate.inflate(Base64.decode64(encoded_data))
      rescue
        encoded_data
      end
    end
  end
end