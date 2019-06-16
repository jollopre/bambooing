require 'spec_helper'
require 'support/configuration_shared_context'

RSpec.describe Bambooing::Timesheet::Clock::Entry do
  include_context 'configuration'

  let(:date) { Date.new(2019,05,25) }
  let(:start) { Time.new(date.year, date.month, date.day, 8, 30) }
  let(:_end) { Time.new(date.year, date.month, date.day, 13, 30) }
  let(:entry) do
    { id: 1, tracking_id: 1, employee_id: 1, date: date, start: start, end: _end, note: 'a note' }
  end

  describe '.initialize' do
    it 'instantiates an entry object' do
      result = described_class.new(entry)

      expect(result.id).to eq(1)
      expect(result.tracking_id).to eq(1)
      expect(result.employee_id).to eq(1)
      expect(result.date).to eq(date)
      expect(result.start).to eq(start)
      expect(result.end).to eq(_end)
      expect(result.note).to eq('a note')
    end
  end

  describe '#to_json' do
    it 'returns stringyfied json' do
      an_entry = described_class.new(entry)

      result = an_entry.to_json

      expect(result).to eq('{"id":1,"trackingId":1,"employeeId":1,"date":"2019-05-25","start":"08:30","end":"13:30","note":"a note"}')
    end
  end

  describe '.save' do
    let(:entry) do
      described_class.new(date: date, start: start, end: _end)
    end

    context 'when an entry is received' do
      it 'saves it' do
        stub_save(request_body: [entry])

        result = described_class.save(entry)

        expect(result).to eq(true)
      end

      context 'when does not succeeds' do
        it 'logs status and body' do
          allow(Bambooing.logger).to receive(:error)
          stub_save(request_body: [entry], status: 409, response_body: { message: "cannot add duplicate entry" })

          described_class.save(entry)

          expect(Bambooing.logger).to have_received(:error).with(/status: 409, body: {"message":/)
        end
      end
    end

    context 'when multiple entries are received' do
      let(:entries) do
        [entry]
      end
      it 'saves them' do
        stub_save(request_body: entries)

        result = described_class.save(entries)

        expect(result).to eq(true)
      end

      context 'when does not succeeds' do
        it 'logs status and body' do
          allow(Bambooing.logger).to receive(:error)
          stub_save(request_body: entries, status: 409, response_body: { message: "cannot add duplicate entry" })

          described_class.save(entry)

          expect(Bambooing.logger).to have_received(:error).with(/status: 409, body: {"message":/)
        end
      end
    end

    def stub_save(request_body: [], status: 200, response_body: "")
      headers = { 'Content-type' => 'application/json;charset=UTF-8', 'Cookie' => "PHPSESSID=a_session_id", 'X-Csrf-Token' => 'a_secret' }
      body = { entries: request_body }.to_json

      stub_request(:post, 'https://flywire.bamboohr.com/timesheet/clock/entries').with(body: body, headers: headers).to_return(status: status, body: response_body.to_json, headers: {})
    end
  end
end
