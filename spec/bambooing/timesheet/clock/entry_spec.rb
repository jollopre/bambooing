require 'bambooing/timesheet/clock/entry'

RSpec.describe Bambooing::Timesheet::Clock::Entry do
  let(:entry) do
    { id: 1, tracking_id: 1, employee_id: 1, date: '2019-05-25', start: '8:30', end: '13:30', note: 'a note' }
  end

  describe '.initialize' do
    it 'instantiates an entry object' do
      result = described_class.new(entry)

      expect(result.id).to eq(1)
      expect(result.tracking_id).to eq(1)
      expect(result.employee_id).to eq(1)
      expect(result.date).to eq('2019-05-25')
      expect(result.start).to eq('8:30')
      expect(result.end).to eq('13:30')
      expect(result.note).to eq('a note')
    end
  end

  describe '#to_json' do
    it 'returns stringyfied json' do
      an_entry = described_class.new(entry)

      result = an_entry.to_json

      expect(result).to eq('{"id":1,"trackingId":1,"employeeId":1,"date":"2019-05-25","start":"8:30","end":"13:30","note":"a note"}')
    end
  end

  describe '.save' do
    let(:x_csrf_token) { 'a_token' }
    let(:session_id) { 'a_session_id' }
    let(:employee_id) { 111 }
    let(:entry) do
      described_class.new(date: '2019-05-26', start: '8:30', end: '13:30')
    end

    before do
      Bambooing.configure do |config|
        config.x_csrf_token = x_csrf_token
        config.session_id = session_id
        config.employee_id = employee_id
      end
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

          result = described_class.save(entry)

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
          pending
        end
      end
    end

    def stub_save(request_body: [], status: 200, response_body: "")
      headers = { 'Content-type' => 'application/json;charset=UTF-8', 'Cookie' => "PHPSESSID=#{session_id}", 'X-Csrf-Token' => x_csrf_token }
      body = { entries: request_body }.to_json

      stub_request(:post, 'https://flywire.bamboohr.com/timesheet/clock/entries').with(body: body, headers: headers).to_return(status: status, body: response_body.to_json, headers: {})
    end
  end
end
