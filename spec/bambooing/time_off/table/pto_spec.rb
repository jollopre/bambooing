require 'spec_helper'
require 'support/configuration_shared_context'

RSpec.describe Bambooing::TimeOff::Table::PTO do
  include_context 'configuration'
  let(:employee_class) { Bambooing::TimeOff::Employee }
  
  describe '.approved' do
    let(:request_class) do
      Bambooing::TimeOff::Table::Request
    end
    let(:requests) do
      [
        request_class.new(status: 'rejected'),
        request_class.new(status: 'approved')
      ]
    end

    it 'every request status is approved' do
      allow(described_class).to receive(:where).with(employee_id: 1, type_id: anything, year: 2019).and_return(requests)
<<<<<<< Updated upstream
      allow(employee_class).to receive(:pto_types).with(1).and_return([77,81])
      result = described_class.approved(employee_id: 1, year: 2019)

=======
      result = described_class.approved(employee_id: 1, year: 2019)

      expect(result.size) >= 1
>>>>>>> Stashed changes
      expect(result).to all(have_attributes(status: 'approved'))
    end
  end
end
