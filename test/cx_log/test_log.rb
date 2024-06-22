# frozen_string_literal: true

require "test_helper"

class TestLog < Minitest::Test
  def test_that_it_can_override_message
    cx_log = CxLog::Log.instance
    cx_log.add(message: "hello")
    assert_equal({ message: "hello" }, cx_log.context)
  end

  def test_that_it_can_add_an_event
    cx_log = CxLog::Log.instance
    cx_log.add(foo: "bar")
    assert_equal({ message: "", foo: "bar" }, cx_log.context)
  end

  def test_that_it_can_append
    cx_log = CxLog::Log.instance
    cx_log.add(foo: "bar")
    cx_log.add(foo: "baz")
    assert_equal({ message: "", foo: ["bar", "baz"] }, cx_log.context)
  end

  def that_it_can_clear
    cx_log = CxLog::Log.instance
    cx_log.add(foo: "bar")
    cx_log.clear
    assert_equal({ message: "" }, cx_log.context)
  end

  def test_that_it_can_flush
    logger = Minitest::Mock.new
    logger.expect :info, nil, [{ message: "", foo: "bar" }.to_json]

    cx_log = CxLog::Log.instance
    cx_log.add(foo: "bar")
    cx_log.flush(logger)

    logger.verify
  end
end
