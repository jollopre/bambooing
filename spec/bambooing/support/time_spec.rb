RSpec.describe Bambooing::Support::Time do
  describe '.rand_work' do
    let(:hours) { 8 }
    let(:start_hour) { 8 }
    let(:breaks) { 2 }

    it 'returns an array of hashes' do
      result = described_class.rand_work(hours: 8, start_hour: 8, breaks: 2)

      expect(result).to all(include(:start).and include(:end))
    end

    it 'first start period starts at start_hour' do
      result = described_class.rand_work(hours: hours, start_hour: start_hour, breaks: breaks)

      expect(result.first).to include(start: /^8:/)
    end

    context 'when 1 break is set' do
      it 'returns two periods' do
        result = described_class.rand_work(hours: hours, start_hour: start_hour, breaks: 1)

        expect(result.size).to eq(2)
      end
    end
  end
end
