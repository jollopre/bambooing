RSpec.shared_examples_for 'boolean writer' do
  let(:configuration) { described_class.new }

  it 'sets to false' do
    configuration.send(writer, false)

    expect(configuration.send(reader)).to eq(false)
  end

  context "when writer is set to 'true'" do
    it 'returns true' do
      configuration.send(writer, 'true')

      expect(configuration.send(reader)).to eq(true)
    end
  end

  context 'when writer is set to 1' do
    context 'as an Integer' do
      it 'returns true' do
        configuration.send(writer, 1)

        expect(configuration.send(reader)).to eq(true)
      end
    end
    context 'as a String' do
      it 'returns true' do
        configuration.send(writer, '1')

        expect(configuration.send(reader)).to eq(true)
      end
    end
  end
end
