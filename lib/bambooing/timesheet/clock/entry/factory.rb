module Bambooing
  module Timesheet
    module Clock
      class Entry
        class Factory
          class << self
            def create_current_weekdays
              cweekdays = Support::Date.cweekdays
              employee_id = Bambooing.configuration.employee_id
              entries = []
              cweekdays.each do |weekday|
                periods = Support::Time.rand_work(date: weekday, hours: 8, starting_hour: 8, breaks: 2)
                periods.each do |period|
                  entries << Entry.new(date: weekday, start: period[:start], end: period[:end], employee_id: employee_id)
                end
              end

              entries
            end
          end
        end
      end
    end
  end
end
