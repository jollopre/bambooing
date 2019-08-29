require 'bambooing'

namespace :bambooing do
  desc 'creates entries in bamboo for the current month weekdays'
  task :create_current_month_weekdays do
    Bambooing::Configuration.load_from_environment!

    entries = entry_class::Factory.create_current_month_weekdays(employee_id: employee_id, exclude_time_off: exclude_time_off)

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
