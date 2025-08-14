require 'spec_helper'

RSpec.describe Bambooing::TimeOff::Table::DigitalDisconnectDay do
  let(:employee_id) { 'test_employee' }
  let(:year) { 2025 }

  describe '.approved' do
    let(:request_class) do
      Bambooing::TimeOff::Table::Request
    end
    let(:requests) do
      [
        request_class.new(status: 'rejected', type_id: 102),
        request_class.new(status: 'approved', type_id: 102)
      ]
    end

    it 'returns only approved digital disconnect days' do
      allow(described_class).to receive(:where).with(employee_id: employee_id, type_id: 102, year: year).and_return(requests)
      result = described_class.approved(employee_id: employee_id, year: year)

      expect(result.size).to eq(1)
      expect(result).to all(have_attributes(status: 'approved'))
    end
  end
end