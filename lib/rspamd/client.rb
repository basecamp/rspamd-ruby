require "rspamd/service"
require "rspamd/check/result"
require "rspamd/errors"

module Rspamd
  class Client
    def initialize(scheme: "http", host:)
      @endpoint = Endpoint.new(scheme: scheme, host: host)
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
      service.post("/learnspam", body: message).then do |response|
        JSON.parse(response.body).then do |body|
          unless body["success"]
            raise LearningFailed, body["error"].presence || "Received unspecified error from Rspamd"
          end
        end
      end
    end

    def ham!(message)
      service.post("/learnham", body: message).then do |response|
        JSON.parse(response.body).then do |body|
          unless body["success"]
            raise LearningFailed, body["error"].presence || "Received unspecified error from Rspamd"
          end
        end
      end
    end

    private
      attr_reader :endpoint

      def service
        @service ||= Service.new(endpoint)
      end
  end
end
