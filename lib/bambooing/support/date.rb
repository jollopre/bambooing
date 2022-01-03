require 'date'

module Bambooing
  module Support
    class Date
      MONDAY = 1.freeze
      FRIDAY = 5.freeze
      WEEKDAYS = (1..5).freeze
      class << self
        def cweekdays
          current_day = today
          days = []
          direction = :next_day

          while days[0].nil? || days[4].nil?
            if WEEKDAYS.include?(current_day.wday)
              days[current_day.wday - 1] = current_day
            else
              direction = :prev_day if current_day.wday > FRIDAY
              direction = :next_day if current_day.wday < MONDAY
              current_day = today
            end
            current_day = current_day.send(direction)
          end

          days
        end

        def cmonth_weekdays
          day = today - today.mday + 1
          end_of_month = today.next_month - today.next_month.mday
          days = []

          while day <= end_of_month
            days << day if WEEKDAYS.include?(day.wday)
            day = day.next_day
          end

          days
        end

        def cyear
          today.year
        end

        private

        def today
          #::Date.new(2021,12,31)
          ::Date.today
        end
      end
    end
  end
end
