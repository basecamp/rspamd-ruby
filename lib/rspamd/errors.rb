module Rspamd
  class Error < StandardError; end
  class InvalidResponse < Error; end
  class LearningFailed < Error; end
end
