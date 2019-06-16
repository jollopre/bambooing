require 'spec_helper'
require 'support/rake_shared_context'
require 'support/configuration_shared_context'

RSpec.describe 'rake create_current_weekdays', type: :task do
  include_context 'rake'
  include_context 'configuration'

  let(:entry_model) { Bambooing::Timesheet::Clock::Entry }
  let(:factory) { entry_model::Factory }

  before do
    allow(Bambooing::Configuration).to receive(:load_from_environment!)
    allow(Bambooing.logger).to receive(:info)
    allow(entry_model).to receive(:save)
  end

  it 'generates entries for the current weekdays' do
    allow(factory).to receive(:create_current_weekdays).and_call_original

    task.invoke

    expect(factory).to have_received(:create_current_weekdays)
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

      expect(entry_model).to have_received(:save)
    end
  end

  context 'when dry_run_mode is true' do
    before do
      Bambooing.configure { |config| config.dry_run_mode = true }
    end

    it 'it DOES NOT save entries generated in bamboo' do
      task.invoke

      expect(entry_model).not_to have_received(:save)
    end
  end
end
