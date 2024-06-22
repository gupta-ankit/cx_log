# frozen_string_literal: true

# Load all files
Dir[File.join(__dir__, "cx_log", "**", "*.rb")].sort.each { |file| require file }

module CxLog
  class Error < StandardError; end
  # Your code goes here...
end
