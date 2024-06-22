# frozen_string_literal: true

module CxLog
  module Formatters
    # Formats data with plain text. Given a hash with key (k) and value (v),
    # the formatter will return a string with the format "k=v ..."
    class KeyValue
      def call(data)
        data.map { |key, value| "#{key}=#{value}" }.join(" ")
      end
    end
  end
end
