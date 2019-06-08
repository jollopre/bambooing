require 'rake'

RSpec.shared_context 'rake' do
  let(:task_name) { self.class.top_level_description.sub(/\Arake /, '') }
  let(:task_path) { "tasks/#{task_name}" }
  let(:tasks) { Rake::Task }
  subject(:task) { tasks[task_name] }

  before do
    Rake.application.rake_require(task_path)
  end

  after(:each) do
    task.reenable
  end
end
