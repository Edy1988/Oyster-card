require 'oystercard'
describe Oystercard do

  it 'has a balance' do
    expect(subject.balance).to eq @balance
  end
end
