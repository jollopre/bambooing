require 'spec_helper'
require 'timecop'
require_relative 'shared_examples'

RSpec.describe Bambooing::Timesheet::Clock::Entry::Factory do
  let(:employee_id) { 'an_employee_id' }
  let(:pto_class) { Bambooing::TimeOff::Table::PTO }

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

  def seconds_worked_for(entries)
    entries.reduce(0) do |acc, entry|
      acc += entry.end.to_i - entry.start.to_i
    end
  end
end
