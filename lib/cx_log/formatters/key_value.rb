module CxLog
  module Formatters
    class KeyValue
      def call(data)
        data.map { |key, value| "#{key}=#{value}" }.join(" ")
      end
    end
  end
end
