module Bambooing
  class Configuration
    class << self
      def load_from_environment!
        Bambooing.configure do |config|
          config.host = ENV.fetch('BAMBOOING_HOST', '')
          config.x_csrf_token = ENV.fetch('BAMBOOING_X_CSRF_TOKEN', '')
          config.session_id = ENV.fetch('BAMBOOING_SESSION_ID', '')
          config.employee_id = ENV.fetch('BAMBOOING_EMPLOYEE_ID', '')
          config.dry_run_mode = ENV.fetch('BAMBOOING_DRY_RUN_MODE', '')
          config.exclude_time_off = ENV.fetch('BAMBOOING_EXCLUDE_TIME_OFF', '')
        end
      end
    end

    attr_accessor :host, :x_csrf_token, :session_id, :employee_id
    attr_reader :dry_run_mode, :exclude_time_off

    def dry_run_mode=(value)
      @dry_run_mode = to_boolean(value)
    end

    def exclude_time_off=(value)
      @exclude_time_off = to_boolean(value)
    end

    private

    def to_boolean(value)
      /true|1/.match?(value.to_s)
    end
  end
end
