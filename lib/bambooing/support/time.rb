require 'date'

module Bambooing
  module Support
    class Time
      class << self
        def rand_work(hours:, start_hour:, breaks:)
          today = ::Date.today
          periods = []

          if breaks == 1
            period_seconds = hours/(breaks + 1) * 60
          end
          start = ::Time.new(today.year, today.mon, today.day, start_hour, Random.rand(60), 0)
          _end = nil
          periods << { start: "#{start.hour}:#{start.min}", end: _end }

          periods
        end
      end
    end
  end
end
