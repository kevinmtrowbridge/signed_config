module SignedConfig
  class Reader
    def initialize(public_key, signed_config)
      yml = signed_config.split("\n")[1..-2].join("\n")
      hash = YAML.load(yml)
      signature = hash[:signature]
      @config_string = hash[:config]

      unless Crypto.verify(public_key, signature, @config_string)
        raise SignatureDoesNotMatch
      end
    end

    def config
      YAML.load(@config_string)
    end
  end
end