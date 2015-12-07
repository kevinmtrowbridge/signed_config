require 'minitest/autorun'
require 'signed_config'

class SignedConfigTest < Minitest::Test

  def test_flow
    private_key_path = File.expand_path("../support/test_private.key", __FILE__)
    private_key = File.open(private_key_path, 'rb') { |f| f.read }
    config_hash = {
      :num_users => '1',
      :functionality_enabled => false
    }

    writer = SignedConfig::Writer.new(private_key, config_hash)
    signed_config = writer.signed_config

    assert signed_config

    public_key_path = File.expand_path("../support/test_private.key", __FILE__)
    public_key = File.open(public_key_path, 'rb') { |f| f.read }
    reader = SignedConfig::Reader.new(public_key, signed_config)

    config = reader.config
    assert config[:num_users] == '1'
    assert config[:functionality_enabled] == false
  end
end