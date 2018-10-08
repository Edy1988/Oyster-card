require 'oystercard'
describe Oystercard do

  it 'has a balance' do
    expect(subject.balance).to eq 0
  end

  it 'increases balance by top up value' do
    card = Oystercard.new(0)
    card.top_up(30)
    expect(card.balance).to eq 30
  end

  it 'has a limit of £90' do
    card = Oystercard.new(90)
    expect { card.top_up(10) }.to raise_error "Unable to top up, maximum #{Oystercard::LIMIT}"
  end

  it "raises an error if balance exceeds limit" do
  card = Oystercard.new
  expect { card.top_up(100) }.to raise_error "Unable to top up, maximum #{Oystercard::LIMIT}"
end
end
