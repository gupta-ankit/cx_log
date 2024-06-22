# frozen_string_literal: true

require "test_helper"

class TestLog < Minitest::Test
  def setup
    @log = Class.new(CxLog::Log).instance
  end

  def test_that_it_can_override_message
    @log.add(message: "hello")
    assert_equal({ message: "hello" }, @log.context)
  end

  def test_that_it_can_add_an_event
    @log.add(foo: "bar")
    assert_equal({ message: "", foo: "bar" }, @log.context)
  end

  def test_that_it_can_append
    @log.add(foo: "bar")
    @log.add(foo: "baz")
    assert_equal({ message: "", foo: %w[bar baz] }, @log.context)
  end

  def that_it_can_clear
    @log.add(foo: "bar")
    @log.clear
    assert_equal({ message: "" }, @log.context)
  end

  def test_that_it_can_flush
    logger = Minitest::Mock.new
    logger.expect :info, nil, [{ message: "", foo: "bar" }.to_json]

    @log.add(foo: "bar")
    @log.flush(logger)

    logger.verify
  end
end
