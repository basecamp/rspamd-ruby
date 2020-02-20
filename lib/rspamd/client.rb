require "rspamd/configuration"
require "rspamd/service"
require "rspamd/check/result"
require "rspamd/errors"

module Rspamd
  class Client
    attr_reader :configuration

    def initialize(**options)
      @configuration = Configuration.new(**options)
    end

    def ping
      service.get("/ping")
        .then { |response| response.is_a?(Net::HTTPOK) && response.body.match?(/\Apong(\r?\n)?\z/) }
    rescue Net::OpenTimeout, Net::ReadTimeout, IOError, SystemCallError
      false
    end

    def check(message)
      service.post("/checkv2", body: message).then do |response|
        if response.is_a?(Net::HTTPOK)
          Check::Result.parse(response.body)
        else
          raise InvalidResponse, "Received invalid response from Rspamd: expected 200 OK, got #{response.code} #{response.message}".strip
        end
      end
    end

    def spam!(message)
      learn :spam, message
    end

    def ham!(message)
      learn :ham, message
    end

    private
      def service
        @service ||= Service.new(configuration)
      end

      def learn(classification, message)
        service.post("/learn#{classification}", body: message)
          .then { |response| JSON.parse(response.body) }
          .then do |body|
            if body["success"]
              true
            else
              raise LearningFailed, body["error"] || "Received unspecified error from Rspamd"
            end
          end
      end
  end
end
