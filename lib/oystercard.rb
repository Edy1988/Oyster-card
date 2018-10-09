require_relative 'station'

class Oystercard

  attr_reader :balance
  attr_reader :entry_station
  attr_reader :exit_station

  LIMIT = 90
  MINIMUM = 1

  def initialize(balance = 0)
    @balance = balance
    @entry_station = nil
    @exit_station = exit_station
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
    @exit_station = nil
  end

  def touch_out(exit_station)
    @balance -= MINIMUM
    @entry_station = nil
    @exit_station = exit_station
  end
end
