require 'spec_helper'

RSpec.shared_context 'configuration' do
  before(:each) do
    Bambooing.configure do |config|
      config.host = 'https://my_company.bamboohr.com'
      config.x_csrf_token = 'a_secret'
      config.session_id = 'a_session_id'
      config.employee_id = 'an_employee_id'
      config.dry_run_mode = true
    end
  end
end
