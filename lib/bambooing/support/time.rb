require 'date'

module Bambooing
  module Support
    class Time
      class << self
        ONE_MINUTE_SECONDS = 60.freeze
        ONE_HOUR_MINUTES = 60.freeze
        ONE_HOUR_SECONDS = ONE_HOUR_MINUTES*ONE_MINUTE_SECONDS.freeze
        MAX_BREAK_MINUTES = ONE_HOUR_MINUTES

        def rand_work(date: nil, hours:, start_hour:, breaks:)
          today = date || ::Date.today
          periods = []

          seconds_per_period = hours/(breaks + 1.0) * ONE_HOUR_SECONDS
          start = ::Time.new(today.year, today.mon, today.day, start_hour, Random.rand(MAX_BREAK_MINUTES), 0)
          _end = ::Time.at(start.to_i + seconds_per_period)
          periods << { start: start, end: _end }

          (0..breaks).reduce(periods) do |acc, i|
            if i+1 <= breaks
              period = acc[i]
              start = ::Time.at(period[:end].to_i + Random.rand(MAX_BREAK_MINUTES)*ONE_MINUTE_SECONDS)
              next_period = {
                start: start,
                end: ::Time.at(start.to_i + seconds_per_period)
              }
              acc[i+1] = next_period
            end
            acc
          end
        end
      end
    end
  end
end
