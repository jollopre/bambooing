module Bambooing
  class Configuration
    attr_accessor :x_csrf_token, :session_id, :employee_id
    attr_reader :dry_run_mode

    def dry_run_mode=(value)
      @dry_run_mode = /true|1/.match?(value.to_s)
    end

    class << self
      def load_from_environment!
        Bambooing.configure do |config|
          config.x_csrf_token = ENV.fetch('BAMBOOING_X_CSRF_TOKEN', '')
          config.session_id = ENV.fetch('BAMBOOING_SESSION_ID', '')
          config.employee_id = ENV.fetch('BAMBOOING_EMPLOYEE_ID', '')
          config.dry_run_mode = ENV.fetch('BAMBOOING_DRY_RUN_MODE', '')
        end
      end
    end
  end
end
