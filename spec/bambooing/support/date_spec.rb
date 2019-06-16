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

    after do
      Timecop.return
    end
  end
end
