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


    def open_timeout
      options[:open_timeout] || 1
    end

    def read_timeout
      options[:read_timeout] || 10
    end


    def user_agent
      options[:user_agent] || "rspamd-ruby"
    end

    def password
      options[:password]
    end
  end
end
