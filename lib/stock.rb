require_relative 'bollinger_bands'

class Stock
  require 'yahoofinance'

  def initialize(stock_sym)
    @quote_type = YahooFinance::StandardQuote
    @stock_sym = stock_sym.to_s.upcase

    @quotes = []
    get_quotes
  end

  def get_quotes
    # YahooFinance::get_quotes( quote_type, @stock_sym ) do |qt|
    #   puts "QUOTING: #{qt.symbol}"
    #   puts qt.to_s
    # end
    @quotes = YahooFinance::get_standard_quotes(@stock_sym)
  end

  # The elements of the array are:
  #   [0] - Date
  #   [1] - Open
  #   [2] - High
  #   [3] - Low
  #   [4] - Close
  #   [5] - Volume
  #   [6] - Adjusted Close
  def get_historical_quotes(days = 30)
    YahooFinance::get_historical_quotes_days(@stock_sym, days)
  end

  def get_historical_closes(days = 30)
    Hash.new.tap do |h|
      get_historical_quotes(days).each do |q|
        h[q[0]] = q[6]
      end
    end
  end

  def method_missing(meth, *args, &blk)
    @quotes[@stock_sym].send(meth, *args, &blk)
  end

  def bollinger_bands
    b = BollingerBands.new
    b.compute_bollinger(get_historical_closes.values.map(&:to_i))
  end
end