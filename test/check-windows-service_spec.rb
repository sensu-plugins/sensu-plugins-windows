require_relative '../bin/check-windows-service.rb'

describe CheckWinService do
  before(:all) do
    CheckWinService.class_variable_set(:@@autorun, nil)
  end

  let(:check) do
    CheckWinService.new ['--service', 'A Sample Service']
  end

  it 'should use quotes' do
    expect(check).to receive(:system).with('tasklist /svc|findstr /i /c:"A Sample Service"').and_raise SystemExit
    expect { check.run }.to raise_error SystemExit
  end
end
