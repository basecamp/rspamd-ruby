module Rspamd
  module Check
    class Result
      attr_reader :data

      def self.parse(source)
        new JSON.parse(source)
      end

      def initialize(data = {})
        @data = data
      end

      def spam?
        score >= required_score
      end

      def ham?
        !spam?
      end

      def skipped?
        data.fetch("is_skipped")
      end

      def score
        data.fetch("score")
      end

      def required_score
        data.fetch("required_score")
      end

      def action
        data.fetch("action")
      end

      def symbols
        data.fetch("symbols")
      end

      def subject
        data["subject"]
      end

      def urls
        data["urls"] || []
      end

      def emails
        data["emails"] || []
      end

      def message_id
        data["message_id"]
      end
    end
  end
end
