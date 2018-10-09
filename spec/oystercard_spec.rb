require 'oystercard'
require 'station'
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
    card.touch_in(entry_station)
    expect(card.in_journey?).to eq true
  end

  it 'should be in_jouney when touching in' do
    card = Oystercard.new(2)
    card.touch_in(entry_station)
    card.touch_out(exit_station)
    expect(card.in_journey?).to eq false
  end

  it 'raises an error if there is an insufficient balance upon touch_in (£1)' do
    card = Oystercard.new
    expect { card.touch_in(entry_station) }.to raise_error "Insufficient funds - less then #{Oystercard::MINIMUM}"
  end

  it "should reduce the balance by minimum fare when touching out" do
    card = Oystercard.new(2)
    card.touch_in(entry_station)
    expect { card.touch_out(exit_station) }.to change { card.balance }.by(-Oystercard::MINIMUM)
  end

  let(:entry_station) { double :entry_station }
  it 'should save entry_station when touched in' do
    card = Oystercard.new(2)
    allow(card).to receive(:entry_station).and_return(entry_station)
  end
  let(:entry_station) { double :entry_station }
  it 'should forget entry station when you touch out' do
    card = Oystercard.new
    allow(card).to receive(:entry_station)
    expect(card.touch_out(exit_station)).to eq exit_station
  end

  let(:exit_station) { double :exit_station }
  it 'should save exit_station when touched out' do
    card = Oystercard.new(2)
    station = EntryStation.new
    allow(card.touch_in(station)).to receive(:exit_station).and_return(exit_station)
  end

  let(:exit_station) { double :exit_station }
  it 'should forget exit station when you touch in' do
    card = Oystercard.new(12)
    station = EntryStation.new
    card.touch_in(station)
    allow(card).to receive(:exit_station)
    expect(card.touch_in(exit_station)).to eq nil
  end
  let(:journeys) { {entry_station: entry_station, exit_station: exit_station} }
  it 'stores a journey' do
    card = Oystercard.new
    card.top_up(12)
    entry_station = EntryStation.new
    card.touch_in(entry_station)
    exit_station = ExitStation.new
    card.touch_out(exit_station)
    expect(card.journey(entry_station, exit_station)).to eq(entry_station=>exit_station)
  end
end
