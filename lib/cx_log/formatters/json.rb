# frozen_string_literal: true

require "json"

module CxLog
  module Formatters
    # Formats data as JSON
    class Json
      def call(data)
        JSON.dump(data)
      end
    end
  end
end
