require 'date'

module Bambooing
  module Support
    class Time
      class << self
        def rand_work(hours:, start_hour:, breaks:)
          today = ::Date.today
          periods = []

          start = ::Time.new(today.year, today.mon, today.day, start_hour, Random.rand(60), 0)
          periods << { start: "#{start.hour}:#{start.min}" }

          periods
        end
      end
    end
  end
end
