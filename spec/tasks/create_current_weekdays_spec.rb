require 'support/rake_shared_context'

RSpec.describe 'rake create_current_weekdays', type: :task do
  include_context 'rake'

  it 'prints todo' do
    task.invoke
  end
end
