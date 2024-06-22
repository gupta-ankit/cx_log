# frozen_string_literal: true

require "singleton"
module CxLog
  # internal class to store the events for a single log entry
  class Log
    include Singleton

    attr_reader :context, :options

    class << self
      def add(**kwargs)
        instance.add(**kwargs)
      end

      def clear
        instance.clear
      end

      def flush
        instance.flush
      end

      def options=(**options)
        instance.options = options
      end
    end

    def default_context
      {
        message: ""
      }
    end

    def default_options
      {
        formatter: CxLog::Formatters::Json.new,
        filter_parameters: %i[passw secret token key _key salt cert]
      }
    end

    def initialize
      @context = default_context
      @options = default_options
    end

    def options=(options)
      @options = default_options.merge(options)
    end

    def add(**kwargs)
      kwargs.each do |key, value|
        @context[key] = if @context.key?(key) && key.to_sym != :message
                          [@context[key], value].flatten
                        else
                          value
                        end
      end
      # return instance to allow chaining
      self
    end

    def clear
      @context = default_context
    end

    def flush(logger)
      log_level = @context.key?(:error) ? :error : :info
      logger.public_send(log_level, @options[:formatter].call(sanitized_context))
      clear
    end

    def sanitized_context
      @context.to_a.map do |key, value|
        if sensitive_key?(key)
          [key, "[FILTERED]"]
        else
          [key, value]
        end
      end.to_h
    end

    def sensitive_key?(key)
      regex = Regexp.union(@options[:filter_parameters].map(&:to_s))
      key.to_s.match?(regex)
    end
  end
end
