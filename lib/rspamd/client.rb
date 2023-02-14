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

    def check(message, headers: {})
      service.post("/checkv2", headers: headers, body: message).then do |response|
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

    def add_fuzzy(message, flag: 1, weight: 1)
      post("/fuzzyadd", message, "Flag" => flag, "Weight" => weight)
    end

    def delete_fuzzy(message, flag: 1)
      post("/fuzzydel", message, "Flag" => flag)
    end

    private
      def service
        @service ||= Service.new(configuration)
      end

      def learn(classification, message)
        post("/learn#{classification}", message)
      end

      def post(endpoint, body, **headers)
        service.post(endpoint, body: body, headers: headers).then do |response|
          case response
          when Net::HTTPOK
            JSON.parse(response.body).fetch("success")
          when Net::HTTPNoContent, Net::HTTPAlreadyReported
            false
          else
            raise Rspamd::Error, JSON.parse(response.body)["error"] || "Received unspecified error from Rspamd"
          end
        end
      end
  end
end
