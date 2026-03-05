require "test_helper"

class Rspamd::ClientStubTest < Minitest::Test
  def setup
    @stub = Rspamd::ClientStub.new
  end

  def test_ping_returns_true
    assert @stub.ping
  end

  def test_check_returns_ham_result
    result = @stub.check("message body")
    assert result.ham?
    assert_not result.spam?
    assert_equal 0.0, result.score
    assert_equal 15.0, result.required_score
    assert_equal "no action", result.action
  end

  def test_check_accepts_headers
    result = @stub.check("message body", headers: { "Settings-Id" => "outbound" })
    assert result.ham?
  end

  def test_spam_returns_true
    assert @stub.spam!("message body")
  end

  def test_ham_returns_true
    assert @stub.ham!("message body")
  end

  def test_add_fuzzy_returns_true
    assert @stub.add_fuzzy("message body")
  end

  def test_delete_fuzzy_returns_true
    assert @stub.delete_fuzzy("message body")
  end

  private
    def assert_not(value)
      assert !value
    end
end
