require 'logger'
require 'bambooing/version'
require 'bambooing/timesheet/clock/entry'

module Bambooing
  class << self
    attr_reader :configuration

    def configure
      @configuration ||= Configuration.new
      yield(configuration)

      self
    end

    def logger
      unless defined?(@logger)
        @logger = Logger.new(STDOUT)
      end
      @logger
    end
  end

  class Configuration
    attr_accessor :x_csrf_token, :session_id, :employee_id
  end
end
