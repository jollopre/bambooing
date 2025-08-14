require 'spec_helper'
require_relative 'configuration/shared_example_for_boolean_writer'

RSpec.describe Bambooing::Configuration do
  describe '#dry_run_mode=' do
    let(:writer) { :dry_run_mode= }
    let(:reader) { :dry_run_mode }

    it_behaves_like 'boolean writer'
  end

  describe '#exclude_time_off=' do
    let(:writer) { :exclude_time_off= }
    let(:reader) { :exclude_time_off }

    it_behaves_like 'boolean writer'
  end

  describe '#exclude_ptos=' do
    let(:writer) { :exclude_ptos= }
    let(:reader) { :exclude_ptos }

    it_behaves_like 'boolean writer'
  end

  describe '#exclude_digital_disconnect_days=' do
    let(:writer) { :exclude_digital_disconnect_days= }
    let(:reader) { :exclude_digital_disconnect_days }

    it_behaves_like 'boolean writer'
  end


  describe '.load_from_environment' do
    let!(:host) { ENV['BAMBOOING_HOST'] }
    let!(:x_csrf_token) { ENV['BAMBOOING_X_CSRF_TOKEN'] }
    let!(:session_id) { ENV['BAMBOOING_SESSION_ID'] }
    let!(:employee_id) { ENV['BAMBOOING_EMPLOYEE_ID'] }
    let!(:dry_run_mode) { ENV['BAMBOOING_DRY_RUN_MODE'] }
    let!(:exclude_time_off) { ENV['BAMBOOING_EXCLUDE_TIME_OFF'] }
    let!(:exclude_ptos) { ENV['BAMBOOING_EXCLUDE_PTOS'] }
    let!(:exclude_digital_disconnect_days) { ENV['BAMBOOING_EXCLUDE_DIGITAL_DISCONNECT_DAYS'] }

    it 'sets every configuration variable to its corresponding environment variable' do
      ENV['BAMBOOING_HOST'] = 'https://my_company.bamboohr.com'
      ENV['BAMBOOING_X_CSRF_TOKEN'] = 'a_csrf_token'
      ENV['BAMBOOING_SESSION_ID'] = 'a_session_id'
      ENV['BAMBOOING_EMPLOYEE_ID'] = 'a_employee_id'
      ENV['BAMBOOING_DRY_RUN_MODE'] = 'true'
      ENV['BAMBOOING_EXCLUDE_TIME_OFF'] = 'true'
      ENV['BAMBOOING_EXCLUDE_PTOS'] = 'true'
      ENV['BAMBOOING_EXCLUDE_DIGITAL_DISCONNECT_DAYS'] = 'true'
      described_class.load_from_environment!

      configuration = Bambooing.configuration
      expect(configuration.host).to eq('https://my_company.bamboohr.com')
      expect(configuration.x_csrf_token).to eq('a_csrf_token')
      expect(configuration.session_id).to eq('a_session_id')
      expect(configuration.employee_id).to eq('a_employee_id')
      expect(configuration.dry_run_mode).to eq(true)
      expect(configuration.exclude_time_off).to eq(true)
      expect(configuration.exclude_ptos).to eq(true)
      expect(configuration.exclude_digital_disconnect_days).to eq(true)
    end

    after(:each) do
      ENV['BAMBOOING_HOST'] = host
      ENV['BAMBOOING_X_CSRF_TOKEN'] = x_csrf_token
      ENV['BAMBOOING_SESSION_ID'] = session_id
      ENV['BAMBOOING_EMPLOYEE_ID'] = employee_id
      ENV['BAMBOOING_DRY_RUN_MODE'] = dry_run_mode
      ENV['BAMBOOING_EXCLUDE_TIME_OFF'] = exclude_time_off
      ENV['BAMBOOING_EXCLUDE_PTOS'] = exclude_ptos
      ENV['BAMBOOING_EXCLUDE_DIGITAL_DISCONNECT_DAYS'] = exclude_digital_disconnect_days
    end
  end
end
