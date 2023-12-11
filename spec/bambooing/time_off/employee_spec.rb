require 'spec_helper'
require 'support/configuration_shared_context'

RSpec.describe Bambooing::TimeOff::Employee do
  include_context 'configuration'

  let(:employee_id) { 1 }
  let(:pto_types) { [77,81] }
  let(:path) { "/time_off/employee" }

  describe '.where' do
    let(:params) do
      {
        employeeId: 1
      }
    end
    let(:payload) do
      {
        policies: [
            { categoryId: 77 }, { categoryId: 81 }
        ]
      }
    end

    it 'returns a list of PTO types by employee_id' do
      allow(Bambooing::Client).to receive(:get).with(path: path, params: params, headers: {}).and_return(payload)

      result = described_class.pto_types(employee_id)

      expect(result.size).to eq(2)

      expect(result).to all(be_kind_of(Numeric))
    end

    context 'when an error is raised' do
      context 'since a response redirection is received' do
        it 'returns empty list' do
          allow(Bambooing::Client).to receive(:get).with(path: path, params: params, headers: {}).and_raise(Bambooing::Client::Redirection)

          result = described_class.pto_types(employee_id)

          expect(result).to eq([])
        end
      end

      context 'since there is a client error' do
        it 'returns empty list' do
          allow(Bambooing::Client).to receive(:get).with(path: path, params: params, headers: {}).and_raise(Bambooing::Client::ClientError)

          result = described_class.pto_types(employee_id)

          expect(result).to eq([])
        end
      end

      context 'since there is a server error' do
        it 'returns empty list' do
          allow(Bambooing::Client).to receive(:get).with(path: path, params: params, headers: {}).and_raise(Bambooing::Client::ServerError)

          result = described_class.pto_types(employee_id)

          expect(result).to eq([])
        end
      end

      context 'since an unknown response is received' do
        it 'returns empty list' do
          allow(Bambooing::Client).to receive(:get).with(path: path, params: params, headers: {}).and_raise(Bambooing::Client::UnknownResponse)

          result = described_class.pto_types(employee_id)

          expect(result).to eq([])
        end
      end
    end
  end
end