require 'spec_helper'
require 'bambooing/configuration'

RSpec.describe Bambooing::Configuration do
  describe '#dry_run_mode=' do
    let(:configuration) { described_class.new }

    it 'sets dry_run_mode' do
      configuration.dry_run_mode = false

      expect(configuration.dry_run_mode).to eq(false)
    end

    context "when dry_run_mode is set to 'true'" do
      it 'returns true' do
        configuration.dry_run_mode = 'true'

        expect(configuration.dry_run_mode).to eq(true)
      end
    end

    context 'when dry_run_mode is set to 1' do
      context 'as an Integer' do
        it 'returns true' do
          configuration.dry_run_mode = 1

          expect(configuration.dry_run_mode).to eq(true)
        end
      end
      context 'as a String' do
        it 'returns true' do
          configuration.dry_run_mode = '1'

          expect(configuration.dry_run_mode).to eq(true)
        end
      end
    end
  end

  describe '.load_from_environment' do
    let!(:host) { ENV['BAMBOOING_HOST'] }
    let!(:x_csrf_token) { ENV['BAMBOOING_X_CSRF_TOKEN'] }
    let!(:session_id) { ENV['BAMBOOING_SESSION_ID'] }
    let!(:employee_id) { ENV['BAMBOOING_EMPLOYEE_ID'] }
    let!(:dry_run_mode) { ENV['BAMBOOING_DRY_RUN_MODE'] }

    it 'sets every configuration variable to its corresponding environment variable' do
      ENV['BAMBOOING_HOST'] = 'https://my_company.bamboohr.com'
      ENV['BAMBOOING_X_CSRF_TOKEN'] = 'a_csrf_token'
      ENV['BAMBOOING_SESSION_ID'] = 'a_session_id'
      ENV['BAMBOOING_EMPLOYEE_ID'] = 'a_employee_id'
      ENV['BAMBOOING_DRY_RUN_MODE'] = 'true'

      described_class.load_from_environment!

      configuration = Bambooing.configuration
      expect(configuration.host).to eq('https://my_company.bamboohr.com')
      expect(configuration.x_csrf_token).to eq('a_csrf_token')
      expect(configuration.session_id).to eq('a_session_id')
      expect(configuration.employee_id).to eq('a_employee_id')
      expect(configuration.dry_run_mode).to eq(true)
    end

    after(:each) do
      ENV['BAMBOOING_HOST'] = host
      ENV['BAMBOOING_X_CSRF_TOKEN'] = x_csrf_token
      ENV['BAMBOOING_SESSION_ID'] = session_id
      ENV['BAMBOOING_EMPLOYEE_ID'] = employee_id
      ENV['BAMBOOING_DRY_RUN_MODE'] = dry_run_mode
    end
  end
end
