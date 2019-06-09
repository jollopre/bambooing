require 'bambooing'

desc 'creates entries in bamboo for the current weekdays'
task :create_current_weekdays do
  Bambooing::Configuration.load_from_environment!

  entry_model = Bambooing::Timesheet::Clock::Entry
  dry_run_mode = Bambooing.configuration.dry_run_mode

  entries = entry_model::Factory.create_current_weekdays
  Bambooing.logger.info(entries)
  entry_model.save(entries) unless dry_run_mode
end
