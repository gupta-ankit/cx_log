# frozen_string_literal: true

# Load all files
Dir[File.join(__dir__, "cx_log", "**", "*.rb")].sort.each { |file| require file }

module CxLog
  # Your code goes here...
  def self.add(**kwargs)
    Log.add(**kwargs)
  end

  def self.clear
    Log.clear
  end

  def self.flush(logger)
    Log.flush(logger)
  end

  def self.options=(options)
    Log.options = options
  end
end
