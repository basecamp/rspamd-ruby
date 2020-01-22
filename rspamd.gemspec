Gem::Specification.new do |s|
  s.name     = "rspamd"
  s.version  = "0.1.0"
  s.authors  = "George Claghorn"
  s.email    = "george@basecamp.com"
  s.summary  = "Client for Rspamd's HTTP API"
  s.homepage = "https://github.com/basecamp/rspamd-ruby"

  s.required_ruby_version = ">= 2.6.0"

  s.add_dependency "activesupport", ">= 6.0.0"
  s.add_dependency "addressable",   ">= 2.7.0"

  s.add_development_dependency "rake",     "~> 13.0"
  s.add_development_dependency "minitest", "~> 5.11"
  s.add_development_dependency "webmock",  "~> 3.0"
  s.add_development_dependency "byebug",   "~> 9.1"

  s.files      = `git ls-files`.split("\n")
  s.test_files = `git ls-files -- test/*`.split("\n")
end
