require "test_helper"

class Rspamd::SetupTest < Minitest::Test
  def teardown
    Rspamd.reset!
  end

  def test_returns_stub_when_disabled
    Rspamd.setup("enabled" => false, "outbound" => { "host" => "localhost", "port" => 11334 })

    client = Rspamd.client_for(:outbound)
    assert_instance_of Rspamd::ClientStub, client
  end

  def test_returns_client_when_enabled
    Rspamd.setup("enabled" => true, "outbound" => { "host" => "rspamd.example.com", "port" => 11334 })

    client = Rspamd.client_for(:outbound)
    assert_instance_of Rspamd::Client, client
  end

  def test_caches_client_instances
    Rspamd.setup("enabled" => true, "outbound" => { "host" => "localhost", "port" => 11334 })

    client1 = Rspamd.client_for(:outbound)
    client2 = Rspamd.client_for(:outbound)
    assert_same client1, client2
  end

  def test_returns_stub_when_config_is_nil
    Rspamd.setup(nil)

    client = Rspamd.client_for(:outbound)
    assert_instance_of Rspamd::ClientStub, client
  end

  def test_returns_stub_when_not_configured
    client = Rspamd.client_for(:outbound)
    assert_instance_of Rspamd::ClientStub, client
  end

  def test_raises_for_unknown_client_name
    Rspamd.setup("enabled" => true, "outbound" => { "host" => "localhost", "port" => 11334 })

    assert_raises(ArgumentError) { Rspamd.client_for(:nonexistent) }
  end

  def test_reset_clears_config_and_clients
    Rspamd.setup("enabled" => true, "outbound" => { "host" => "localhost", "port" => 11334 })
    Rspamd.client_for(:outbound)
    Rspamd.reset!

    # After reset, should return stub (no config = disabled)
    client = Rspamd.client_for(:outbound)
    assert_instance_of Rspamd::ClientStub, client
  end

  def test_accepts_symbol_keys
    Rspamd.setup(enabled: true, outbound: { host: "localhost", port: 11334 })

    client = Rspamd.client_for(:outbound)
    assert_instance_of Rspamd::Client, client
  end

  def test_passes_password_to_client
    Rspamd.setup("enabled" => true, "outbound" => { "host" => "localhost", "port" => 11334, "password" => "secret" })

    client = Rspamd.client_for(:outbound)
    assert_equal "secret", client.configuration.password
  end
end
