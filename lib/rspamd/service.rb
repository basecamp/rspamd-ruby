module Rspamd
  class Service
    attr_reader :configuration

    def initialize(configuration)
      @configuration = configuration
    end

    def get(path)
      client.get path, "User-Agent" => configuration.user_agent
    end

    def post(path, headers: {}, body: nil)
      client.post path, body, headers.merge("User-Agent" => configuration.user_agent)
    end

    private
      def client
        @client ||= Net::HTTP.start \
          configuration.host,
          configuration.port,
          use_ssl: configuration.scheme == "https",
          open_timeout: configuration.open_timeout,
          read_timeout: configuration.read_timeout
      end
  end
end
