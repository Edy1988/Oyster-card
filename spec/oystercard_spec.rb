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

  it 'deducts an amount from balance' do
    card = Oystercard.new(10)
    card.deduct(5)
    expect(card.balance).to eq 5
  end

  it 'should not be in_journey before touching in' do
    card = Oystercard.new
    expect(card.in_journey?).to eq false
  end

  it 'should be in_jouney when touching in' do
    card = Oystercard.new(5)
    card.touch_in
    expect(card.in_journey?).to eq true
  end

  it 'should be in_jouney when touching in' do
    card = Oystercard.new(2)
    card.touch_in
    card.touch_out
    expect(card.in_journey?).to eq false
  end

  it 'raises an error if there is an insufficient balance upon touch_in (£1)' do
    card = Oystercard.new
    expect { card.touch_in }.to raise_error "Insufficient funds - less then #{Oystercard::MINIMUM}"
  end

  it "should reduce the balance by minimum fare when touching out" do
    card = Oystercard.new(2)
    card.touch_in
    expect { card.touch_out }.to change { card.balance }.by(-Oystercard::MINIMUM)
  end

end
