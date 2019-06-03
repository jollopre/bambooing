RSpec.describe Bambooing::Timesheet::Clock::Entry::Factory do
  before do
    Bambooing.configure do |config|
      config.employee_id = '1234'
    end
  end
  describe '.create_current_weekdays' do
    it 'returns entries for current weekdays' do
      result = described_class.create_current_weekdays

      expect(result).to all(be_a(Bambooing::Timesheet::Clock::Entry))
    end

    it 'every entry has date set' do
      result = described_class.create_current_weekdays

      dates = result.map(&:date)
      expect(dates).to all(be_a(Date))
    end

    it 'every entry has start set' do
      result = described_class.create_current_weekdays

      starts = result.map(&:start)
      expect(starts).to all(be_a(Time))
    end

    it 'every entry has end set' do
      result = described_class.create_current_weekdays

      ends = result.map(&:end)
      expect(ends).to all(be_a(Time))
    end

    it '40 hours are worked' do
      result = described_class.create_current_weekdays

      elapsed_seconds = result.reduce(0) do |acc, entry|
        acc += entry.end.to_i - entry.start.to_i
      end
      expect(elapsed_seconds).to eq(40*60*60)
    end
  end
end
