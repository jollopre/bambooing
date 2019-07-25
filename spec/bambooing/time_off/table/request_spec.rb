require 'spec_helper'
require 'support/configuration_shared_context'

RSpec.describe Bambooing::TimeOff::Table::Request do
  include_context 'configuration'

  let(:id) { 1 }
  let(:employee_id) { 1 }
  let(:start) { Date.new(2019,07,23) }
  let(:_end) { Date.new(2019,07,25) }
  let(:status) { 'approved' }

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

  describe '.find_by_pto' do
    let(:params) do
      {
        employee_id: employee_id,
        type: described_class::TYPES[:pto],
        year: 2019
      }
    end
    let(:response_body) do
      {
        requests: {
          1 => { id: id, employee_id: employee_id, startYmd: '2019-07-23', endYmd: '2019-07-25', timeOffTypeId: 77, status: 'approved' }
        }
      }
    end

    it 'returns a list of PTO requests by employee_id and year' do
      stub_get(params: params, status: 200, response_body: response_body)

      result = described_class.find_by_pto(employee_id: employee_id,year: 2019)

      expect(result).to all(have_attributes(type_id: described_class::TYPES[:pto]))
    end

    context 'when does not succeeds' do
      let(:response_body) do
        { success: 'false', error: 'wadus' }
      end

      before do
        stub_get(params: params, status: 200, response_body: response_body)
      end

      context 'since success is false within the response body payload' do
        it 'returns empty list' do
          result = described_class.find_by_pto(employee_id: employee_id, year: 2019)

          expect(result).to eq([])
        end

        it 'logs status and body' do
          allow(Bambooing.logger).to receive(:error)

          described_class.find_by_pto(employee_id: employee_id, year: 2019)

          expect(Bambooing.logger).to have_received(:error).with(/status: 200, body: {\"success\":\"false\",\"error\":\"wadus\"}/)
        end
      end

      context 'since 4XX or 5XX is received' do
        it 'returns empty list' do
          pending
        end

        it 'logs status and body' do
          pending
        end
      end
    end

    def stub_get(params: {}, status: 200, response_body: '')
      headers = { 'Content-type' => 'application/json;charset=UTF-8', 'Cookie' => "PHPSESSID=a_session_id", 'X-Csrf-Token' => 'a_secret' }

      stub_request(:get, "#{Bambooing.configuration.host}/time_off/table/requests?id=#{params[:employee_id]}&type=#{params[:type]}&year=#{params[:year]}").with(headers: headers).to_return(status: status, body: response_body.to_json, headers: {})
    end
  end
end
