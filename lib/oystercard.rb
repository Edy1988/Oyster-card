require_relative 'entry_station'

class Oystercard

  attr_reader :balance
  attr_reader :entry_station

  LIMIT = 90
  MINIMUM = 1

  def initialize(balance = 0)
    @balance = balance
    @entry_station = nil
  end

  def top_up(amount)
    raise "Unable to top up, maximum #{LIMIT}" if @balance + amount >= LIMIT
    @balance += amount
  end

  def deduct(amount)
    @balance -= amount
  end

  def in_journey?
    !!entry_station
  end

  def touch_in(entry_station)
    raise "Insufficient funds - less then #{MINIMUM}" if @balance < MINIMUM
    @entry_station = entry_station
  end

  def touch_out
    @balance -= MINIMUM
    @entry_station = nil
  end
end
