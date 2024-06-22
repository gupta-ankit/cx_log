# frozen_string_literal: true

module CxLog
  # Rails middleware to emit a contextual log line for each request
  class Middleware
    def initialize(app, **kwargs)
      @app = app
      CxLog::Log.instance.options = kwargs
    end

    def call(env)
      CxLog::Log.add(request_id: env["action_dispatch.request_id"])
      method = env["REQUEST_METHOD"]
      route = Rails.application.routes.recognize_path(env["PATH_INFO"])
      CxLog::Log.instance.add(
        controller: route[:controller],
        action: route[:action],
        method: method
      )
      @app.call(env)
    rescue StandardError => e
      CxLog::Log.instance.add(error: e.message)
      raise e
    ensure
      CxLog::Log.instance.flush(Rails.logger)
    end
  end
end
