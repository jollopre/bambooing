module Bambooing
  module Timesheet
    module Clock
      class Entry
        class Factory
          class << self
            def create_current_weekdays(employee_id:, exclude_time_off: false)
              cweekdays = Support::Date.cweekdays
              cweekdays = exclude_time_off(employee_id, cweekdays) if exclude_time_off

              entries = []
              cweekdays.each do |weekday|
                periods = Support::Time.rand_work(date: weekday, hours: 8, starting_hour: 8, breaks: 2)
                periods.each do |period|
                  entries << Entry.new(date: weekday, start: period[:start], end: period[:end], employee_id: employee_id)
                end
              end

              entries
            end

            private

            def exclude_time_off(employee_id, days)
              year = Support::Date.cyear
              requests = Bambooing::TimeOff::Table::PTO.approved(employee_id: employee_id, year: year)

              days.reject do |day|
                requests.any? do |request|
                  day >= request.start && day <= request.end
                end
              end
            end
          end
        end
      end
    end
  end
end
