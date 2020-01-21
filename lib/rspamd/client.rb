require "rspamd/service"

module Rspamd
  class Client
    def initialize(scheme: "http", host:)
      @service = Service.new(scheme: scheme, host: host)
    end

    def ping
      @service.get("/ping")
        .then { |response| response.is_a?(Net::HTTPOK) && response.body == "pong" }
    end
  end
end
