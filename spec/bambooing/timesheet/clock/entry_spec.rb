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

  describe '#to_h' do
    it 'returns hash' do
      an_entry = described_class.new(entry)

      result = an_entry.to_h

      expect(result).to eq({ id: 1, trackingId: 1, employeeId: 1, date: '2019-05-25', start: '08:30', end: '13:30', note: 'a note' })
    end
  end

  describe '.save' do
    let(:entry) do
      described_class.new(date: date, start: start, end: _end)
    end

    context 'when an entry is received' do
      it 'saves it' do
        allow(Bambooing::Client).to receive(:post).with(path: '/timesheet/clock/entries', params: { entries: [entry.to_h] }, headers: {})

        result = described_class.save(entry)

        expect(result).to eq(true)
      end

      context 'when an error is raised' do
        context 'since there is a client error' do
          it 'returns false' do
            allow(Bambooing::Client).to receive(:post).and_raise(Bambooing::Client::ClientError)

            result = described_class.save(entry)

            expect(result).to eq(false)
          end
        end
      end
    end

    context 'when multiple entries are received' do
      let(:entries) { [entry] }

      it 'saves them' do
        hashed_entries = entries.map(&:to_h)
        allow(Bambooing::Client).to receive(:post).with(path: '/timesheet/clock/entries', params: { entries: hashed_entries }, headers: {})

        result = described_class.save(entries)

        expect(result).to eq(true)
      end
    end
  end
end
