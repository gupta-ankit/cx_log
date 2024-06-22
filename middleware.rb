module CxLog
  class Middleware
    def initialize(app, **kwargs)
      @app = app
      ContextLog.instance.options = kwargs
    end

    def call(env)
      ContextLog.add(request_id: env["action_dispatch.request_id"])
      method = env["REQUEST_METHOD"]
      route = Rails.application.routes.recognize_path(env["PATH_INFO"])
      ContextLog.instance.add(
        controller: route[:controller],
        action: route[:action],
        method: method
      )
      @app.call(env)
    rescue StandardError => e
      ContextLog.instance.add(error: e.message)
      raise e
    ensure
      ContextLog.instance.flush(Rails.logger)
    end
  end
end
