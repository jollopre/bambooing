require "bambooing/version"

module Bambooing
  class << self
    attr_reader :configuration

    def configure
      @configuration ||= Configuration.new
      yield(configuration)

      self
    end
  end

  class Configuration
    attr_accessor :x_csrf_token, :session_id
  end
end
