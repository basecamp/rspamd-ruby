module Rspamd
  class Configuration
    attr_reader :options

    def initialize(**options)
      @options = options
    end

    def scheme
      options[:scheme] || "http"
    end

    def host
      options[:host] || "localhost"
    end

    def port
      options[:port] || 11333
    end

    def endpoint
      @endpoint ||= Endpoint.new(scheme: scheme, host: host, port: port)
    end


    def open_timeout
      options[:open_timeout]
    end

    def read_timeout
      options[:read_timeout]
    end


    def user_agent
      options[:user_agent] || "rspamd-ruby"
    end
  end
end
