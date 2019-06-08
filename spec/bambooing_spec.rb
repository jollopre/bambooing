RSpec.describe Bambooing do
  it 'has a version number' do
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

    it 'sets employee_id' do
      described_class.configure do |config|
        config.employee_id = 1234
      end

      result = described_class.configuration.employee_id
      expect(result).to eq(1234)
    end

    context 'config.dry_run_mode' do
      it 'sets dry_run_mode' do
        described_class.configure do |config|
          config.dry_run_mode = false
        end

        result = described_class.configuration.dry_run_mode
        expect(result).to eq(false)
      end

      context "when dry_run_mode is set to 'true'" do
        it 'returns true' do
          described_class.configure do |config|
            config.dry_run_mode = 'true'
          end

          result = described_class.configuration.dry_run_mode
          expect(result).to eq(true)
        end
      end

      context 'when dry_run_mode is set to 1' do
        context 'as an Integer' do
          it 'returns true' do
            described_class.configure do |config|
              config.dry_run_mode = 1
            end

            result = described_class.configuration.dry_run_mode
            expect(result).to eq(true)
          end
        end
        context 'as a String' do
          it 'returns true' do
            described_class.configure do |config|
              config.dry_run_mode = '1'
            end

            result = described_class.configuration.dry_run_mode
            expect(result).to eq(true)
          end
        end
      end
    end
  end
end
