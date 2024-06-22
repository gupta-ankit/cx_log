module CxLog
  class Log
    include Singleton

    attr_reader :context, :options

    class << self
      delegate :add, :clear, :flush, :"options=", to: :instance
    end

    def default_context
      {
        message: ""
      }
    end

    def default_options
      {
        formatter: JsonFormatter.new
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
        if @context.key?(key)
          @context[key] = [@context[key], value].flatten
        else
          @context[key] = value
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
