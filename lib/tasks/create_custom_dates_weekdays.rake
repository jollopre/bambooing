require 'bambooing'

namespace :bambooing do
  desc 'creates entries in bamboo between the provided dates weekdays'
  task :create_custom_dates_weekdays, [:start_date, :end_date] do |t, args|
    Bambooing::Configuration.load_from_environment!

    entries = entry_class::Factory.create_custom_dates_weekdays(employee_id: employee_id, exclude_time_off: exclude_time_off, start_date: args[:start_date], end_date: args[:end_date])

    Bambooing.logger.info(entries)

    entry_class.save(entries) unless dry_run_mode?
  end

  def dry_run_mode?
    Bambooing.configuration.dry_run_mode
  end

  def employee_id
    Bambooing.configuration.employee_id
  end

  def exclude_time_off
    Bambooing.configuration.exclude_time_off
  end

  def entry_class
    Bambooing::Timesheet::Clock::Entry
  end
end
