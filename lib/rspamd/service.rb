require "rspamd/endpoint"

module Rspamd
  class Service
    def initialize(endpoint)
      @endpoint = endpoint
    end

    def get(path)
      Net::HTTP.get_response @endpoint.url_for(path)
    end

    def post(path, headers: {}, body: nil)
      Net::HTTP.post @endpoint.url_for(path), body, headers
    end
  end
end
