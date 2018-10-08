class Oystercard

  attr_reader :balance

  LIMIT = 90

  def initialize(balance = 0)
    @balance = balance
  end

  def top_up(amount)
    raise "Unable to top up, maximum #{LIMIT}" if @balance >= LIMIT
    @balance += amount
  end

end
