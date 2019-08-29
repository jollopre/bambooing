require 'spec_helper'
require 'timecop'

RSpec.describe Bambooing::Support::Date do
  describe '.cweekdays' do
    before do
      Timecop.freeze(Date.new(2019,5,28))
    end
    it 'returns the weekdays for the current week' do
      result = described_class.cweekdays

      expect(result).to eq([
        Date.new(2019,5,27),
        Date.new(2019,5,28),
        Date.new(2019,5,29),
        Date.new(2019,5,30),
        Date.new(2019,5,31)
      ])
    end

    after { Timecop.return }
  end

  describe '.cmonth_weekdays' do
    before do
      Timecop.freeze(Date.new(2019,8,29))
    end

    it 'returns the weekdays for the current month' do
      result = described_class.cmonth_weekdays

      mdays = [1,2,5,6,7,8,9,12,13,14,15,16,19,20,21,22,23,26,27,28,29,30]
      expected_result = mdays.map { |mday| Date.new(2019,8,mday) }
      expect(result).to eq(expected_result)
    end

    after { Timecop.return }
  end

  describe '.cyear' do
    before { Timecop.freeze(Date.new(2019,7,28)) }

    it "returns today's year" do
      result = described_class.cyear

      expect(result).to eq(2019)
    end

    after { Timecop.return }
  end
end
