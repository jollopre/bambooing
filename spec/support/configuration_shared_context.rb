RSpec.shared_context 'configuration' do
  Bambooing.configure do |config|
    config.x_csrf_token = 'a_secret'
    config.session_id = 'a_session_id'
    config.employee_id = 'an_employee_id'
  end
end
