require 'logger'
require 'bambooing/version'
require 'bambooing/configuration'
require 'bambooing/timesheet/clock/entry'
require 'bambooing/timesheet/clock/entry/factory'
require 'bambooing/time_off/table/request'
require 'bambooing/support/date'
require 'bambooing/support/time'

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
end
