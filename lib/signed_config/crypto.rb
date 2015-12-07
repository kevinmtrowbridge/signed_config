# Adapted from: https://blog.atechmedia.com/encrypting-signing-data-ruby/

require 'openssl'
require 'base64'

module SignedConfig
  module Crypto

    class << self

      # Return a signature for the string
      def sign(key, string)
        Base64.encode64(rsa_key(key).sign(OpenSSL::Digest::SHA1.new, string))
      end

      # Verify the string and signature
      def verify(key, signature, string)
        rsa_key(key).verify(OpenSSL::Digest::SHA1.new, Base64.decode64(signature), string)
      end

      private

      def rsa_key(key)
        OpenSSL::PKey::RSA.new(key)
      end
    end
  end
end