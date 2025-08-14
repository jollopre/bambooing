require 'spec_helper'

RSpec.describe Bambooing::TimeOff::ExclusionService do
  let(:employee_id) { 'test_employee' }
  let(:year) { 2025 }
  let(:pto_class) { Bambooing::TimeOff::Table::PTO }
  let(:digital_disconnect_class) { Bambooing::TimeOff::Table::DigitalDisconnectDay }

  describe '.excluded_dates' do
    let(:ptos) do
      [pto_class.new(start: Date.new(2025, 8, 1), end: Date.new(2025, 8, 2))]
    end
    
    let(:digital_disconnect_days) do
      [digital_disconnect_class.new(start: Date.new(2025, 8, 15), end: Date.new(2025, 8, 15))]
    end

    before do
      allow(pto_class).to receive(:approved).and_return(ptos)
      allow(digital_disconnect_class).to receive(:approved).and_return(digital_disconnect_days)
    end

    context 'with all exclusions enabled' do
      it 'returns all excluded date ranges' do
        options = {
          exclude_ptos: true,
          exclude_digital_disconnect_days: true
        }
        
        results = described_class.excluded_dates(employee_id: employee_id, year: year, **options)
        
        expect(results.length).to eq(2)
        expect(results).to include(ptos.first)
        expect(results).to include(digital_disconnect_days.first)
      end
    end

    context 'with only PTOs enabled' do
      it 'returns only PTO date ranges' do
        options = {
          exclude_ptos: true,
          exclude_digital_disconnect_days: false
        }
        
        results = described_class.excluded_dates(employee_id: employee_id, year: year, **options)
        
        expect(results.length).to eq(1)
        expect(results).to include(ptos.first)
      end
    end

    context 'with no exclusions enabled' do
      it 'returns empty array' do
        options = {
          exclude_ptos: false,
          exclude_digital_disconnect_days: false
        }
        
        results = described_class.excluded_dates(employee_id: employee_id, year: year, **options)
        
        expect(results).to be_empty
      end
    end
  end
end