require 'spec_helper'
require 'timecop'
require_relative 'shared_examples'

RSpec.describe Bambooing::Timesheet::Clock::Entry::Factory do
  let(:employee_id) { 'an_employee_id' }
  let(:pto_class) { Bambooing::TimeOff::Table::PTO }
  let(:digital_disconnect_class) { Bambooing::TimeOff::Table::DigitalDisconnectDay }
  let(:exclusion_service) { Bambooing::TimeOff::ExclusionService }

  describe '.create_current_weekdays' do
    let(:method) { :create_current_weekdays }

    it_behaves_like 'entry collection'

    it '40 hours are worked' do
      entries = described_class.create_current_weekdays(employee_id: employee_id)

      elapsed_seconds = seconds_worked_for(entries)
      expect(elapsed_seconds).to eq(40*60*60)
    end

    context 'when exclude_time_off is enabled' do
      let(:requests) do
        [pto_class.new(start: Date.new(2019,7,22), end: Date.new(2019,7,23))]
      end
      before do
        Timecop.freeze(Date.new(2019,7,22))
        allow(pto_class).to receive(:approved).and_return(requests)
        allow(digital_disconnect_class).to receive(:approved).and_return([])
      end

      it '24 hours are worked' do
        entries = described_class.create_current_weekdays(employee_id: employee_id, exclude_time_off: true)

        elapsed_seconds = seconds_worked_for(entries)
        expect(elapsed_seconds).to eq(24*60*60)
      end

      after do
        Timecop.return
      end
    end

    context 'when exclude_time_off is enabled with different exclusion types' do
      let(:configuration) { double('configuration') }
      let(:ptos) do
        [pto_class.new(start: Date.new(2019,7,22), end: Date.new(2019,7,22))]
      end
      let(:digital_disconnect_days) do  
        [digital_disconnect_class.new(start: Date.new(2019,7,23), end: Date.new(2019,7,23))]
      end

      before do
        Timecop.freeze(Date.new(2019,7,22))
        allow(Bambooing).to receive(:configuration).and_return(configuration)
      end

      context 'when all exclusions are enabled' do
        before do
          allow(configuration).to receive(:exclude_ptos).and_return(true)
          allow(configuration).to receive(:exclude_digital_disconnect_days).and_return(true)
          
          all_exclusions = ptos + digital_disconnect_days
          allow(exclusion_service).to receive(:excluded_dates).and_return(all_exclusions)
        end

        it '24 hours are worked (excludes Mon, Tue)' do
          entries = described_class.create_current_weekdays(employee_id: employee_id, exclude_time_off: true)

          elapsed_seconds = seconds_worked_for(entries)
          expect(elapsed_seconds).to eq(24*60*60)
        end
      end

      context 'when only PTOs are excluded' do
        before do
          allow(configuration).to receive(:exclude_ptos).and_return(true)
          allow(configuration).to receive(:exclude_digital_disconnect_days).and_return(false)
          
          allow(exclusion_service).to receive(:excluded_dates).and_return(ptos)
        end

        it '32 hours are worked (excludes only Mon)' do
          entries = described_class.create_current_weekdays(employee_id: employee_id, exclude_time_off: true)

          elapsed_seconds = seconds_worked_for(entries)
          expect(elapsed_seconds).to eq(32*60*60)
        end
      end

      after do
        Timecop.return
      end
    end
  end

  describe '.create_current_month_weekdays' do
    let(:method) { :create_current_month_weekdays }

    it_behaves_like 'entry collection'

    it '176 hours are worked' do
      Timecop.freeze(Date.new(2019,8,30))

      entries = described_class.create_current_month_weekdays(employee_id: employee_id)

      elapsed_seconds = seconds_worked_for(entries)
      expect(elapsed_seconds).to eq(176*60*60)
      Timecop.return
    end

    context 'when exclude_time_off is enabled' do
      let(:requests) do
        [pto_class.new(start: Date.new(2019,8,1), end: Date.new(2019,8,2))]
      end
      before do
        Timecop.freeze(Date.new(2019,8,30))
        allow(pto_class).to receive(:approved).and_return(requests)
        allow(digital_disconnect_class).to receive(:approved).and_return([])
      end

      it '160 hours are worked' do
        entries = described_class.create_current_month_weekdays(employee_id: employee_id, exclude_time_off: true)

        elapsed_seconds = seconds_worked_for(entries)
        expect(elapsed_seconds).to eq(160*60*60)
      end

      after do
        Timecop.return
      end
    end
  end

  describe '.create_custom_dates_weekdays' do
    let(:method) { :create_custom_dates_weekdays }
    let(:start_date) { Date.new(2025,3,1) }
    let(:end_date) { Date.new(2025,3,31) }
    let(:requests) do
      [pto_class.new(start: Date.new(2025,3,18), end: Date.new(2025,3,20))]
    end

    before do
      Timecop.freeze(Date.new(2019,8,30))
      allow(pto_class).to receive(:approved).and_return(requests)
      allow(digital_disconnect_class).to receive(:approved).and_return([])
    end

    it '168 hours are worked' do
      entries = described_class.create_custom_dates_weekdays(employee_id: employee_id, start_date: start_date, end_date: end_date)
      elapsed_seconds = seconds_worked_for(entries)
      expect(elapsed_seconds).to eq(168*60*60)
    end

    context 'when exclude_time_off is enabled' do
      it '144 hours are worked' do
        entries = described_class.create_custom_dates_weekdays(employee_id: employee_id, start_date: start_date, end_date: end_date, exclude_time_off: true)
        elapsed_seconds = seconds_worked_for(entries)
        expect(elapsed_seconds).to eq(144*60*60)
      end
    end

    after do
      Timecop.return
    end
  end

  def seconds_worked_for(entries)
    entries.reduce(0) do |acc, entry|
      acc += entry.end.to_i - entry.start.to_i
    end
  end
end
