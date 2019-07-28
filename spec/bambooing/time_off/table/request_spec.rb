require 'spec_helper'
require 'support/configuration_shared_context'

RSpec.describe Bambooing::TimeOff::Table::Request do
  include_context 'configuration'

  let(:id) { 1 }
  let(:employee_id) { 1 }
  let(:start) { Date.new(2019,07,23) }
  let(:_end) { Date.new(2019,07,25) }
  let(:status) { 'approved' }
  let(:type_id) { 77 }
  let(:year) { 2019 }
  let(:path) { "/time_off/table/requests" }

  describe '.initialize' do
    let(:request) do
      { id: id, employee_id: employee_id, start: start, end: _end, status: status }
    end

    it 'instantiates a request object' do
      result = described_class.new(request)

      expect(result.id).to eq(id)
      expect(result.employee_id).to eq(employee_id)
      expect(result.start).to eq(start)
      expect(result.end).to eq(_end)
      expect(result.status).to eq(status)
    end
  end

  describe '.where' do
    let(:params) do
      {
        id: employee_id,
        type: type_id,
        year: year
      }
    end
    let(:payload) do
      {
        success: true,
        requests: {
          "1": { id: 1, employeeId: employee_id, startYmd: '2019-07-23', endYmd: '2019-07-25', timeOffTypeId: type_id, status: 'approved' }
        }
      }
    end

    it 'returns a list of PTO requests by employee_id and year' do
      allow(Bambooing::Client).to receive(:get).with(path: path, params: params, headers: {}).and_return(payload)

      result = described_class.where(employee_id: employee_id, type_id: type_id, year: year)

      expect(result.size).to eq(1)

      expect(result).to all(have_attributes(id: kind_of(Numeric), employee_id: employee_id, start: kind_of(Date), end: kind_of(Date), status: kind_of(String), type_id: type_id))
    end

    context 'when an error is raised' do
      context 'since a response redirection is received' do
        it 'returns empty list' do
          allow(Bambooing::Client).to receive(:get).with(path: path, params: params, headers: {}).and_raise(Bambooing::Client::Redirection)

          result = described_class.where(employee_id: employee_id, type_id: type_id, year: year)

          expect(result).to eq([])
        end
      end

      context 'since there is a client error' do
        it 'returns empty list' do
          allow(Bambooing::Client).to receive(:get).with(path: path, params: params, headers: {}).and_raise(Bambooing::Client::ClientError)

          result = described_class.where(employee_id: employee_id, type_id: type_id, year: year)

          expect(result).to eq([])
        end
      end

      context 'since there is a server error' do
        it 'returns empty list' do
          allow(Bambooing::Client).to receive(:get).with(path: path, params: params, headers: {}).and_raise(Bambooing::Client::ServerError)

          result = described_class.where(employee_id: employee_id, type_id: type_id, year: year)

          expect(result).to eq([])
        end
      end

      context 'since an unknown response is received' do
        it 'returns empty list' do
          allow(Bambooing::Client).to receive(:get).with(path: path, params: params, headers: {}).and_raise(Bambooing::Client::UnknownResponse)

          result = described_class.where(employee_id: employee_id, type_id: type_id, year: year)

          expect(result).to eq([])
        end
      end
    end
  end
end
