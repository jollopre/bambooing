RSpec.describe Bambooing::Support::Time do
  describe '.rand_work' do
    let(:hours) { 8 }
    let(:starting_hour) { 8 }

    it 'returns an array of hashes' do
      result = described_class.rand_work(hours: 8, starting_hour: 8, breaks: 1)

      expect(result).to all(include(:start).and include(:end))
    end

    it 'first start period starts at starting_hour' do
      result = described_class.rand_work(hours: hours, starting_hour: starting_hour, breaks: 1)

      start = result.first[:start].hour
      expect(start).to eq(8)
    end

    context 'when no break is set' do
      it 'returns one period' do
        result = described_class.rand_work(hours: hours, starting_hour: starting_hour, breaks: 0)

        expect(result.size).to eq(1)
      end

      it 'the amount of hours for the period is the hours passed' do
        result = described_class.rand_work(hours: hours, starting_hour: starting_hour, breaks: 0)

        elapsed_seconds = result[0][:end].to_i - result[0][:start].to_i
        expect(hours*60*60).to eq(elapsed_seconds)
      end
    end

    context 'when 1 break is set' do
      it 'returns two periods' do
        result = described_class.rand_work(hours: hours, starting_hour: starting_hour, breaks: 1)

        expect(result.size).to eq(2)
      end

      it 'the amount of hours for the two periods is hours passed' do
        result = described_class.rand_work(hours: hours, starting_hour: starting_hour, breaks: 1)

        first_elapsed_seconds = result[0][:end].to_i - result[0][:start].to_i
        second_elapsed_seconds = result[1][:end].to_i - result[1][:start].to_i
        total_elapsed_seconds = first_elapsed_seconds + second_elapsed_seconds
        expect(hours*60*60).to eq(total_elapsed_seconds)
      end
    end

    context 'when 2 breaks are set' do
      it 'returns three periods' do
        result = described_class.rand_work(hours: hours, starting_hour: starting_hour, breaks: 2)

        expect(result.size).to eq(3)
      end

      it 'the amount of hours for three periods is hours passed' do
        result = described_class.rand_work(hours: hours, starting_hour: starting_hour, breaks: 2)

        first_elapsed_seconds = result[0][:end].to_i - result[0][:start].to_i
        second_elapsed_seconds = result[1][:end].to_i - result[1][:start].to_i
        third_elapsed_seconds = result[2][:end].to_i - result[2][:start].to_i
        total_elapsed_seconds = first_elapsed_seconds + second_elapsed_seconds + third_elapsed_seconds
        expect(hours*60*60).to eq(total_elapsed_seconds)
      end
    end
  end
end
