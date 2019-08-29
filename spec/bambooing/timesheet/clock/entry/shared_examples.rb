RSpec.shared_examples_for 'entry collection' do
  it 'returns entries for current weekdays' do
    result = described_class.send(method, employee_id: employee_id)

    expect(result).to all(be_a(Bambooing::Timesheet::Clock::Entry))
  end

  it 'every entry has same employee_id set' do
    result = described_class.send(method, employee_id: employee_id)

    employee_ids = result.map(&:employee_id)
    expect(employee_ids).to all(eq('an_employee_id'))
  end

  it 'every entry has date set' do
    result = described_class.send(method, employee_id: employee_id)

    dates = result.map(&:date)
    expect(dates).to all(be_a(Date))
  end

  it 'every entry has start set' do
    result = described_class.send(method, employee_id: employee_id)

    starts = result.map(&:start)
    expect(starts).to all(be_a(Time))
  end

  it 'every entry has end set' do
    result = described_class.send(method, employee_id: employee_id)

    ends = result.map(&:end)
    expect(ends).to all(be_a(Time))
  end
end
