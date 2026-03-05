module Rspamd
  class Railtie < ::Rails::Railtie
    initializer "rspamd.setup" do
      config_path = ::Rails.root.join("config/rspamd.yml")

      if config_path.exist?
        Rspamd.setup(::Rails.application.config_for(:rspamd))
      end
    end
  end
end
