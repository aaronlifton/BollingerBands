class BollingerBand
  # Bollinger band parameters
  DEFAULT_PARAMS = {
    num_periods: 20,
    sigma: 2
  }

  #
  # class constructor
  #
  def initialize(periods=20, sigma=2)
    params = {num_periods: periods, sigma: sigma}.merge!(DEFAULT_PARAMS)
    @num_periods, @sigma = params.values
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
      lx = x1 - stddev * @sigma
      ux = x1 + stddev * @sigma
      
      if ((ux - lx) == 0)
        percent_b = 0.0
      else
        percent_b = (x - lx) / (ux - lx)
      
      end
      bandwidth = (ux - lx) / x1
  
      # append to arrays
      # bollinger_bands << [ x1, lx, ux, bandwidth, percent_b ]
      
      # append hash
      bollinger_bands << {sma: x1, lower: lx, upper: ux, bandwidth: bandwidth, percent_b: percent_b}
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