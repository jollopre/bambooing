require 'spec_helper'
require 'support/rake_shared_context'
require 'support/configuration_shared_context'

RSpec.describe 'rake bambooing:create_current_month_weekdays', type: :task do
  include_context 'rake'
  include_context 'configuration'

  let(:configuration) { Bambooing.configuration }
  let(:entry_class) { Bambooing::Timesheet::Clock::Entry }
  let(:factory) { entry_class::Factory }
  let(:pto_class) { Bambooing::TimeOff::Table::PTO }

  before do
    allow(Bambooing::Configuration).to receive(:load_from_environment!)
    allow(Bambooing.logger).to receive(:info)
    allow(entry_class).to receive(:save)
    allow(pto_class).to receive(:approved).and_return([])
  end

  it 'generates entries for the current month weekdays' do
    allow(factory).to receive(:create_current_month_weekdays).and_call_original

    task.invoke

    expect(factory).to have_received(:create_current_month_weekdays).with(employee_id: configuration.employee_id, exclude_time_off: configuration.exclude_time_off)
  end

  it 'logs the entries to be saved' do
    task.invoke

    expect(Bambooing.logger).to have_received(:info)
  end

  context 'when dry_run_mode is false' do
    before do
      Bambooing.configure do |config|
        config.dry_run_mode = false
      end
    end

    it 'saves entries generated in bamboo' do
      task.invoke

      expect(entry_class).to have_received(:save)
    end
  end

  context 'when dry_run_mode is true' do
    before do
      Bambooing.configure { |config| config.dry_run_mode = true }
    end

    it 'it DOES NOT save entries generated in bamboo' do
      task.invoke

      expect(entry_class).not_to have_received(:save)
    end
  end

  context 'when exclude_time_off is true' do
    before do
      Bambooing.configure{ |config| config.exclude_time_off = true }
    end

    it 'generates entries for the current week without time off days' do
      allow(factory).to receive(:create_current_month_weekdays).and_call_original

      task.invoke

      expect(factory).to have_received(:create_current_month_weekdays).with(employee_id: anything, exclude_time_off: true)
    end
  end
end
