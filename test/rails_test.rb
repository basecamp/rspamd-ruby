require "test_helper"

class Rspamd::RailsTest < Minitest::Test
  def teardown
    Rspamd::Rails.reset!
  end

  def test_returns_stub_when_disabled
    Rspamd::Rails.setup("enabled" => false, "outbound" => { "host" => "localhost", "port" => 11334 })

    client = Rspamd::Rails.client_for(:outbound)
    assert_instance_of Rspamd::ClientStub, client
  end

  def test_returns_client_when_enabled
    Rspamd::Rails.setup("enabled" => true, "outbound" => { "host" => "rspamd.example.com", "port" => 11334 })

    client = Rspamd::Rails.client_for(:outbound)
    assert_instance_of Rspamd::Client, client
  end

  def test_caches_client_instances
    Rspamd::Rails.setup("enabled" => true, "outbound" => { "host" => "localhost", "port" => 11334 })

    client1 = Rspamd::Rails.client_for(:outbound)
    client2 = Rspamd::Rails.client_for(:outbound)
    assert_same client1, client2
  end

  def test_returns_stub_when_not_configured
    client = Rspamd::Rails.client_for(:outbound)
    assert_instance_of Rspamd::ClientStub, client
  end

  def test_raises_for_unknown_client_name
    Rspamd::Rails.setup("enabled" => true, "outbound" => { "host" => "localhost", "port" => 11334 })

    assert_raises(ArgumentError) { Rspamd::Rails.client_for(:nonexistent) }
  end

  def test_reset_clears_config_and_clients
    Rspamd::Rails.setup("enabled" => true, "outbound" => { "host" => "localhost", "port" => 11334 })
    Rspamd::Rails.client_for(:outbound)
    Rspamd::Rails.reset!

    # After reset, should return stub (no config = disabled)
    client = Rspamd::Rails.client_for(:outbound)
    assert_instance_of Rspamd::ClientStub, client
  end

  def test_accepts_string_keys
    Rspamd::Rails.setup("enabled" => true, "outbound" => { "host" => "localhost", "port" => 11334 })

    client = Rspamd::Rails.client_for(:outbound)
    assert_instance_of Rspamd::Client, client
  end

  def test_passes_password_to_client
    Rspamd::Rails.setup("enabled" => true, "outbound" => { "host" => "localhost", "port" => 11334, "password" => "secret" })

    client = Rspamd::Rails.client_for(:outbound)
    assert_equal "secret", client.configuration.password
  end
end
