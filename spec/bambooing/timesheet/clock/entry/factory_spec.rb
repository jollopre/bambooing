require 'spec_helper'
require 'timecop'

RSpec.describe Bambooing::Timesheet::Clock::Entry::Factory do
  let(:employee_id) { 'an_employee_id' }
  describe '.create_current_weekdays' do
    it 'returns entries for current weekdays' do
      result = described_class.create_current_weekdays(employee_id: employee_id)

      expect(result).to all(be_a(Bambooing::Timesheet::Clock::Entry))
    end

    it 'every entry has same employee_id set' do
      result = described_class.create_current_weekdays(employee_id: employee_id)

      employee_ids = result.map(&:employee_id)
      expect(employee_ids).to all(eq('an_employee_id'))
    end

    it 'every entry has date set' do
      result = described_class.create_current_weekdays(employee_id: employee_id)

      dates = result.map(&:date)
      expect(dates).to all(be_a(Date))
    end

    it 'every entry has start set' do
      result = described_class.create_current_weekdays(employee_id: employee_id)

      starts = result.map(&:start)
      expect(starts).to all(be_a(Time))
    end

    it 'every entry has end set' do
      result = described_class.create_current_weekdays(employee_id: employee_id)

      ends = result.map(&:end)
      expect(ends).to all(be_a(Time))
    end

    it '40 hours are worked' do
      entries = described_class.create_current_weekdays(employee_id: employee_id)

      elapsed_seconds = seconds_worked_for(entries)
      expect(elapsed_seconds).to eq(40*60*60)
    end

    context 'when exclude_time_off is enabled' do
      let(:pto_class) do
        Bambooing::TimeOff::Table::PTO
      end
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

    def seconds_worked_for(entries)
      entries.reduce(0) do |acc, entry|
        acc += entry.end.to_i - entry.start.to_i
      end
    end
  end
end
