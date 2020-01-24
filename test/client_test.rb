require "test_helper"

class Rspamd::ClientTest < Minitest::Test
  def setup
    @client = Rspamd::Client.new(host: "localhost", port: 11333)
  end

  def test_successfully_pinging
    stub_request(:get, "http://localhost:11333/ping").to_return(status: 200, body: "pong\r\n")
    assert @client.ping
  end

  def test_unsuccessfully_pinging_due_to_a_server_error
    stub_request(:get, "http://localhost:11333/ping").to_return(status: 500)
    assert !@client.ping
  end

  def test_unsuccessfully_pinging_due_to_a_timeout
    stub_request(:get, "http://localhost:11333/ping").to_timeout
    assert !@client.ping
  end

  def test_successfully_checking_a_ham_message
    stub_request(:post, "http://localhost:11333/checkv2")
      .with(body: mail(:ham))
      .to_return(status: 200, body: response("ham.json"))

    result = @client.check(mail(:ham))
    assert !result.spam?
    assert result.ham?
    assert_equal 1.0, result.score
    assert_equal 15.0, result.required_score
    assert_equal "no action", result.action
    assert_equal %w[ foo.example.com bar.example.com baz.example.com ], result.urls
    assert_equal %w[ alice@example.com ], result.emails
  end

  def test_unsuccessfully_checking_a_message_due_to_a_server_error
    stub_request(:post, "http://localhost:11333/checkv2")
      .with(body: mail(:ham))
      .to_return(status: [ 500, "Internal Server Error" ])

    error = assert_raises(Rspamd::InvalidResponse) { @client.check(mail(:ham)) }
    assert_equal "Received invalid response from Rspamd: expected 200 OK, got 500 Internal Server Error", error.message
  end

  def test_successfully_reporting_a_message_as_spam
    request = stub_request(:post, "http://localhost:11333/learnspam")
      .with(body: mail(:ham))
      .to_return(status: 200, body: '{"success": true}')

    assert @client.spam!(mail(:ham))
    assert_requested request
  end

  def test_unsuccessfully_reporting_a_message_as_spam
    stub_request(:post, "http://localhost:11333/learnspam")
      .with(body: mail(:ham))
      .to_return(status: 500, body: '{"error": "Unknown statistics error, found when storing data on backend"}')

    error = assert_raises(Rspamd::LearningFailed) { @client.spam!(mail(:ham)) }
    assert_equal "Unknown statistics error, found when storing data on backend", error.message
  end

  def test_successfully_reporting_a_message_as_ham
    request = stub_request(:post, "http://localhost:11333/learnham")
      .with(body: mail(:ham))
      .to_return(status: 200, body: '{"success": true}')

    assert @client.ham!(mail(:ham))
    assert_requested request
  end

  def test_unsuccessfully_reporting_a_message_as_ham
    stub_request(:post, "http://localhost:11333/learnham")
      .with(body: mail(:ham))
      .to_return(status: 500, body: '{"error": "Unknown statistics error, found when storing data on backend"}')

    error = assert_raises(Rspamd::LearningFailed) { @client.ham!(mail(:ham)) }
    assert_equal "Unknown statistics error, found when storing data on backend", error.message
  end

  private
    def mail(name)
      fixture "mail/#{name}.eml"
    end

    def response(path)
      fixture "responses/#{path}"
    end

    def fixture(path)
      File.read File.expand_path("fixtures/#{path}", __dir__)
    end
end
