RSpec.describe Bambooing do
  it "has a version number" do
    expect(Bambooing::VERSION).not_to be nil
  end
  
  describe '.configure' do
    before(:each) do
      described_class.instance_variable_set(:@configuration, nil)
    end

    let(:configuration_instance) { double(:configuration_instance) }

    it 'yields with Bambooing::Configuration instance as argument' do
      allow(Bambooing::Configuration).to receive(:new).and_return(configuration_instance)

      expect do |b|
        described_class.configure(&b)
      end.to yield_with_args(configuration_instance)
    end

    it 'configuration instance variable is set once only' do
      described_class.configure {}
      configuration = described_class.configuration
      described_class.configure {}
      new_configuration = described_class.configuration

      expect(configuration.object_id).to eq(new_configuration.object_id)
    end

    it 'returns self' do
      result = described_class.configure {}

      expect(result).to eq(described_class)
    end

    it 'sets x_csrf_token' do
      described_class.configure do |config|
        config.x_csrf_token = 'wadus'
      end

      result = described_class.configuration.x_csrf_token

      expect(result).to eq('wadus')
    end

    it 'sets session_id' do
      described_class.configure do |config|
        config.session_id = 'wadus'
      end

      result = described_class.configuration.session_id

      expect(result).to eq('wadus')
    end
  end
end
