require "active_support/core_ext/hash/keys"
require "rspamd/client"
require "rspamd/client_stub"

module Rspamd
  module Rails
    class << self
      def setup(config)
        @config = config.deep_symbolize_keys
        @clients = {}
      end

      def client_for(name)
        return ClientStub.new unless enabled?

        @clients[name] ||= build_client(name)
      end

      def reset!
        @config = nil
        @clients = {}
      end

      private
        def enabled?
          @config&.dig(:enabled)
        end

        def build_client(name)
          settings = @config.fetch(name) { raise ArgumentError, "No rspamd configuration for #{name.inspect}" }
          Client.new(**settings.slice(:host, :port, :password))
        end
    end
  end
end
