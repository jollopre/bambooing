require 'spec_helper'

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

    it 'sets variables for its configuration' do
      described_class.configure do |config|
        config.employee_id = 'a_employee_id'
      end

      employee_id = described_class.configuration.employee_id

      expect(employee_id).to eq('a_employee_id')
    end
  end
end
