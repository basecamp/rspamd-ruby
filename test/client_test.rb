require "test_helper"

class Rspamd::ClientTest < Minitest::Test
  def setup
    @client = Rspamd::Client.new(host: "localhost:11333")
  end

  def test_successfully_pinging
    stub_request(:get, "http://localhost:11333/ping").to_return(status: 200, body: "pong")
    assert @client.ping
  end

  def test_unsuccessfully_pinging
    stub_request(:get, "http://localhost:11333/ping").to_return(status: 500)
    assert !@client.ping
  end
end
