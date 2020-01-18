require 'spec_helper'
require 'support/configuration_shared_context'

RSpec.describe Bambooing::Client do
  include_context 'configuration'

  let(:host) { Bambooing.configuration.host }
  let(:content_type) { { 'Content-Type': 'application/json;charset=UTF-8' }}
  let(:cookie) { { 'Cookie': 'PHPSESSID=a_session_id' }}
  let(:x_csrf_token) { { 'X-Csrf-Token': 'a_secret' }}
  let(:default_headers) do
    content_type.merge(cookie).merge(x_csrf_token)
  end

  describe '.get' do
    let(:path) { '/time_off/table/requests' }
    let(:params) do
      { id: 1, type: 77, year: 2019 }
    end
    let(:query_params) do
      "id=#{params[:id]}&type=#{params[:type]}&year=#{params[:year]}"
    end
    let(:headers) do
      { foo: 'bar' }
    end
    let(:response_body) do
      {
        success: true,
        requests: {
          "1": { id: 1, employeeId: 1, startYmd: '2019-07-23', endYmd: '2019-07-25', timeOffTypeId: '77', status: 'approved' }
        }
      }
    end

    context 'when 200 is received' do
      it 'returns a deserialized response' do
        get_stub(headers: headers, params: params, response: { status: 200, body: response_body, headers: {}})

        response = described_class.get(path: path, params: params, headers: headers)

        expect(response).to eq(response_body)
      end

      context 'and body contains success to false' do
        let(:response_body) do
          {
            success: false,
            error: 'wadus'
          }
        end
        before do
          get_stub(headers: headers, params: params, response: { status: 200, body: response_body, headers: {}})
        end

        it 'raises UnknownResponse' do
          expect do
            described_class.get(path: path, params: params, headers: headers)
          end.to raise_error(described_class::UnknownResponse)
        end

        it 'logs status, body and headers' do
          expect(Bambooing.logger).to receive(:warn).with("Request to #{host}#{path}?#{query_params} responded with status: 200, headers: {}, body: {\"success\":false,\"error\":\"wadus\"}")

          begin
            described_class.get(path: path, params: params, headers: headers)
          rescue
          end
        end
      end
    end

    context 'when 3XX is received' do
      before do
        get_stub(headers: headers, params: params, response: { status: 301, body: nil, headers: { location: 'https://new.host' }})
      end

      it 'raises Redirection' do
        expect do
          described_class.get(path: path, params: params, headers: headers)
        end.to raise_error(described_class::Redirection)
      end

      it 'logs status, body and headers' do
        expect(Bambooing.logger).to receive(:warn).with("Request to #{host}#{path}?#{query_params} responded with status: 301, headers: {\"location\"=>[\"https:\/\/new.host\"]}, body: null")
        begin
          described_class.get(path: path, params: params, headers: headers)
        rescue
        end
      end
    end

    context 'when 4XX is received' do
      before do
        get_stub(headers: headers, params: params, response: { status: 404, body: nil, headers: nil })
      end

      it 'raises ClientError' do
        expect do
          described_class.get(path: path, params: params, headers: headers)
        end.to raise_error(described_class::ClientError)
      end

      it 'logs status, body and headers' do
        expect(Bambooing.logger).to receive(:warn).with("Request to #{host}#{path}?#{query_params} responded with status: 404, headers: {}, body: null")

        begin
          described_class.get(path: path, params: params, headers: headers)
        rescue
        end
      end
    end

    context 'when 5XX is received' do
      before do
        get_stub(headers: headers, params: params, response: { status: 502, body: nil, headers: nil })
      end

      it 'raises ServerError' do
        expect do
          described_class.get(path: path, params: params, headers: headers)
        end.to raise_error(described_class::ServerError)
      end

      it 'logs status, body and headers' do
        expect(Bambooing.logger).to receive(:warn).with("Request to #{host}#{path}?#{query_params} responded with status: 502, headers: {}, body: null")

        begin
          described_class.get(path: path, params: params, headers: headers)
        rescue
        end
      end
    end
  end

  describe '.post' do
    let(:path) { '/timesheet/clock/entries' }
    let(:params) do
      {
        entries: [
          { id: 1, trackingId: 1, employee_id: 1, date: '2019-07-30', start: '8:30', end: '13:30' }
        ]
      }
    end
    let(:headers) do
      { foo: 'bar' }
    end
    let(:response_body) { '' }

    context 'when 200 is received' do
      it 'returns an empty string response' do
        post_stub(headers: headers, params: params, response: { status: 200, body: response_body, headers: {}})

        response = described_class.post(path: path, params: params, headers: headers)

        expect(response).to eq(response_body)
      end
    end

    context 'when 4XX is received' do
      let(:response_body) do
        {
          message: 'Cannot add entries for these times, there are conflicting entries that already exist.',
          trackingIds: [1]
        }
      end
      before do
        post_stub(headers: headers, params: params, response: { status: 409, body: response_body, headers: nil })
      end

      it 'raises ClientError' do
        expect do
          described_class.post(path: path, params: params, headers: headers)
        end.to raise_error(described_class::ClientError)
      end

      it 'logs status, body and headers' do
        expect(Bambooing.logger).to receive(:warn).with("Request to #{host}#{path} responded with status: 409, headers: {}, body: {\"message\":\"Cannot add entries for these times, there are conflicting entries that already exist.\",\"trackingIds\":[1]}")

        begin
          described_class.post(path: path, params: params, headers: headers)
        rescue
        end
      end
    end
  end

  def get_stub(headers: {}, params: {}, response: { status: 200, body: {}, headers: {}})
    headers = default_headers.merge(headers)

    stub_request(:get, "#{host}#{path}?#{query_params}").with(headers: headers).to_return(status: response[:status], body: response[:body].to_json, headers: response[:headers])
  end

  def post_stub(headers: {}, params: {}, response: { status: 200, headers: {}, body: {}})
    headers = default_headers.merge(headers)

    stub_request(:post, "#{host}#{path}").with(headers: headers, body: params.to_json).to_return(status: response[:status], body: response[:body].to_json, headers: response[:headers])
  end
end
