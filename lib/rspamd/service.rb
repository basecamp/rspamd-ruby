module Rspamd
  class Service
    attr_reader :configuration

    def initialize(configuration)
      @configuration = configuration
    end

    def get(path)
      client.get path, default_headers
    end

    def post(path, body: nil, headers: {})
      client.post path, body, default_headers.merge(headers.compact.transform_values(&:to_s))
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

      def default_headers
        {
          "User-Agent" => configuration.user_agent,
          "Password" => configuration.password
        }.compact
      end
  end
end
