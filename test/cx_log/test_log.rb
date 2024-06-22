# frozen_string_literal: true

require "test_helper"
require 'minitest/spec'

describe CxLog::Log do
  def setup
    @log = Class.new(CxLog::Log).instance
  end

  it "test_that_it_can_override_message" do
    @log.add(message: "hello")
    assert_equal({ message: "hello" }, @log.context)
  end

  it "test_that_it_can_add_an_event" do
    @log.add(foo: "bar")
    assert_equal({ message: "", foo: "bar" }, @log.context)
  end

  it "test_that_it_can_append" do
    @log.add(foo: "bar")
    @log.add(foo: "baz")
    assert_equal({ message: "", foo: %w[bar baz] }, @log.context)
  end

  it "that_it_can_clear" do
    @log.add(foo: "bar")
    @log.clear
    assert_equal({ message: "" }, @log.context)
  end

  it "test_that_it_can_flush" do
    logger = Minitest::Mock.new
    logger.expect :info, nil, [{ message: "", foo: "bar" }.to_json]

    @log.add(foo: "bar")
    @log.flush(logger)

    logger.verify
  end

  describe "sensitive_key?" do
    it "returns true for sensitive keys" do
      assert @log.sensitive_key?(:password)
      assert @log.sensitive_key?(:secret)
      assert @log.sensitive_key?(:token)
      assert @log.sensitive_key?(:key)
      assert @log.sensitive_key?(:_key)
      assert @log.sensitive_key?(:salt)
      assert @log.sensitive_key?(:certificate)
    end

    it "returns false for non-sensitive keys" do
      refute @log.sensitive_key?(:foo)
      refute @log.sensitive_key?(:bar)
    end
  end
end
