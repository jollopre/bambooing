module Bambooing
  module Timesheet
    module Clock
      class Entry
        class Factory
          class << self
            def create_current_weekdays(employee_id:, exclude_time_off: false)
              cweekdays = Support::Date.cweekdays
              cweekdays = exclude_time_off(days: cweekdays, employee_id:employee_id) if exclude_time_off
              generate_entries(days: cweekdays, employee_id: employee_id)
            end

            def create_current_month_weekdays(employee_id:, exclude_time_off: false)
              cmonthdays = Support::Date.cmonth_weekdays
              cmonthdays = exclude_time_off(days: cmonthdays, employee_id: employee_id) if exclude_time_off
              generate_entries(days: cmonthdays, employee_id: employee_id)
            end

            def create_custom_dates_weekdays(employee_id:, exclude_time_off: false, start_date:, end_date:)
              days = Support::Date.weekdays_between(start_date: start_date, end_date: end_date)
              days = exclude_time_off(days: days, employee_id: employee_id) if exclude_time_off
              generate_entries(days: days, employee_id: employee_id)
            end

            private

            def generate_entries(days:, employee_id:)
              days.reduce([]) do |acc, weekday|
                periods = Support::Time.rand_work(date: weekday, hours: 8, starting_hour: 8, breaks: 2)
                periods.each do |period|
                  acc << Entry.new(date: weekday, start: period[:start], end: period[:end], employee_id: employee_id)
                end
                acc
              end
            end

            def exclude_time_off(days:, employee_id:)
              year = Support::Date.cyear
              config = Bambooing.configuration
              
              requests = TimeOff::ExclusionService.excluded_dates(
                employee_id: employee_id,
                year: year,
                exclude_ptos: config.exclude_ptos,
                exclude_digital_disconnect_days: config.exclude_digital_disconnect_days
              )

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
