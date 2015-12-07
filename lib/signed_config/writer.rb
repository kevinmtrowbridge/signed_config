module SignedConfig
  class Writer
    def initialize(private_key, config_hash, org_name = nil)
      config_string = YAML::dump(config_hash)
      signature = Crypto.sign(private_key, config_string)
      @org_name = org_name
      @signed_config = YAML::dump({:config => config_string,
                                   :signature => signature})
    end

    def signed_config
      dramatic = '=' * 25
      brand_txt = @org_name ? @org_name + " " : nil

      "#{dramatic}BEGIN #{brand_txt}LICENSE#{dramatic}\n" +
      @signed_config + "\n" +
      "#{dramatic}END #{brand_txt}LICENSE#{dramatic}"
    end
  end
end
