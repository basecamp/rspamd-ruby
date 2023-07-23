Gem::Specification.new do |s|
  s.name     = "rspamd-ruby"
  s.version  = "1.0.0"
  s.authors  = [ "George Claghorn", "Lewis Buckley" ]
  s.email    = "lewis@37signals.com"
  s.summary  = "Client for Rspamd's HTTP API"
  s.homepage = "https://github.com/basecamp/rspamd-ruby"

  s.required_ruby_version = ">= 2.6.0"

  s.add_development_dependency "rake",     "~> 13.0"
  s.add_development_dependency "minitest", "> 5.11"
  s.add_development_dependency "webmock",  "~> 3.0"
  s.add_development_dependency "debug"

  s.files      = `git ls-files`.split("\n")
  s.test_files = `git ls-files -- test/*`.split("\n")
end
