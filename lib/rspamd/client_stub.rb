require "rspamd/check/result"

module Rspamd
  class ClientStub
    HAM_RESULT = Check::Result.new(
      "score" => 0.0,
      "required_score" => 15.0,
      "action" => "no action",
      "is_skipped" => false,
      "symbols" => {},
      "urls" => [],
      "emails" => []
    ).freeze

    def ping
      true
    end

    def check(message, headers: {})
      HAM_RESULT
    end

    def spam!(message)
      true
    end

    def ham!(message)
      true
    end

    def add_fuzzy(message, flag: 1, weight: 1)
      true
    end

    def delete_fuzzy(message, flag: 1)
      true
    end
  end
end
