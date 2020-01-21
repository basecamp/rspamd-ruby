require "rspamd/endpoint"

module Rspamd
  class Service
    def initialize(scheme: "http", host:)
      @endpoint = Endpoint.new(scheme: scheme, host: host)
    end

    def get(path)
      Net::HTTP.get_response @endpoint.url_for(path)
    end
  end
end
