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
        formatter: CxLog::Formatters::Json.new
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
      logger.public_send(log_level, @options[:formatter].call(@context))
      clear
    end
  end
end
