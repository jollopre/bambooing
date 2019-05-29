RSpec.describe Bambooing::Support::Time do
  describe '.rand_work' do
    let(:hours) { 8 }
    let(:start_hour) { 8 }
    let(:n_breaks) { 2 }

    it 'first start period starts at 8' do
      result = described_class.rand_work(hours: 8, start_hour: 8, breaks: 2)

      expect(result.first).to include(start: /^8:/)
    end
  end
end
