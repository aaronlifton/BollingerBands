class BollingerBands
  # Bollinger band parameters
  @num_periods = 20
  @sigma = 2

  #
  # class constructor
  #
  def initialize(periods=20, sigma=2)
    @num_periods=periods
    @sigma=sigma
  end

  #
  # compute Bollinger bands for param "pricelist".
  # "pricelist" contains a list of prices sorted
  # in descending order of period,
  # eg, 31-Jan price comes before 30-Jan price, etc
  #
  # returns Bollinger bands in an array. Each item
  # has:
  # [ middleband, lowerband, upperband, bandwidth, percent_b ]
  #
  def compute_bollinger(pricelist)
    bollinger_bands=[]

    i=0
    size=pricelist.size
    pricelist.each do |x|
      if i + @num_periods > size
        n=size-i
      else
        n=@num_periods
      end
  
      # get subset required for computation
      dataset=pricelist[i, n]
  
      # compute SMA and std deviation
      x1 = comp_simple_moving_avg(dataset)
      stddev = comp_std_deviation(dataset,x1)
  
      # compute lower/upper bands and indicators
      # (percent_b, bandwidth)
      lx= x1 - stddev * @sigma
      ux= x1 + stddev * @sigma
      if (ux-lx == 0)
        percent_b= 0.0
      else
        percent_b =(x - lx) / (ux - lx)
      end
      bandwidth= (ux - lx)/ x1
  
      # append to arrays
      bollinger_bands << [ x1, lx, ux, bandwidth, percent_b ]
      i += 1     
    end      
    bollinger_bands   
  end

  # compute moving average for dataset
  def comp_simple_moving_avg(dataset) 
    dataset.inject(0) { |sum,x| sum+x } / dataset.size
  end
  
  # compute std deviation   
  def comp_std_deviation(dataset, x1)
    y1=dataset.inject(0) { |sum,x|  sum + (x - x1)** 2 }
    Math.sqrt( y1 / dataset.size )
  end
end # class BollingerBands  

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
    h = Hash.new

    get_historical_quotes(days).each do |q|
      h[q[0]] = q[6]
    end
    h
  end

  def method_missing(meth, *args, &blk)
    @quotes[@stock_sym].send(meth, *args, &blk)
  end

  def bollinger_bands
    b = BollingerBands.new
    b.compute_bollinger(get_historical_closes.values.map(&:to_i))
  end
end

s=Stock.new "goog"