require "rspamd/endpoint"

module Rspamd
  class Service
    attr_reader :configuration

    def initialize(configuration)
      @configuration = configuration
    end

    def get(path)
      client.get endpoint.url_for(path), "User-Agent" => configuration.user_agent
    end

    def post(path, headers: {}, body: nil)
      client.post endpoint.url_for(path), body, headers.merge("User-Agent" => configuration.user_agent)
    end

    private
      def endpoint
        configuration.endpoint
      end

      def client
        @client ||= Net::HTTP.start \
          endpoint.host,
          endpoint.port,
          use_ssl: endpoint.secure?,
          open_timeout: configuration.open_timeout,
          read_timeout: configuration.read_timeout
      end
  end
end
