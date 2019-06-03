require 'date'

module Bambooing
  module Support
    class Time
      class << self
        SECONDS_PER_MINUTE = 60.freeze
        MINUTES_PER_HOUR = 60.freeze
        SECONDS_PER_HOUR = MINUTES_PER_HOUR*SECONDS_PER_MINUTE.freeze
        MAX_BREAK_MINUTES = MINUTES_PER_HOUR

        def rand_work(date: nil, hours:, starting_hour:, breaks:)
          day = date || ::Date.today
          seconds_per_period = hours/(breaks + 1.0) * SECONDS_PER_HOUR

          start = ::Time.new(day.year, day.mon, day.day, starting_hour, Random.rand(MAX_BREAK_MINUTES), 0)
          periods = [{
            start: start,
            end: ::Time.at(start.to_i + seconds_per_period)
          }]

          (1..breaks).reduce(periods) do |acc, i|
            period = acc[i-1]

            start = ::Time.at(period[:end].to_i + Random.rand(MAX_BREAK_MINUTES)*SECONDS_PER_MINUTE)
            next_period = {
              start: start,
              end: ::Time.at(start.to_i + seconds_per_period)
            }
            acc[i] = next_period

            acc
          end
        end
      end
    end
  end
end
