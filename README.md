BollingerBands
==============

bollinger bands ruby gem


## Exhibit A.

    s = Stock.new "goog"
    1.9.3 (main)> s.get_historical_quotes(1)
      => [
        [0] [
          [0] "2013-11-25",
          [1] "1037.16",
          [2] "1053.19",
          [3] "1035.02",
          [4] "1045.93",
          [5] "1613000",
          [6] "1045.93"
        ]
      ]
      
    1.9.3 (main)> s.bollinger_bands
      => [
        [ 0] {
                :sma => 1026,
              :lower => 1007.2383369607063,
              :upper => 1044.7616630392938,
          :bandwidth => 0.036572442571722714,
          :percent_b => 1.0063517013445724
        },
        [ 1] {
                :sma => 1024,
              :lower => 1006.6794919243113,
              :upper => 1041.3205080756888,
          :bandwidth => 0.03382911733532967,
          :percent_b => 0.7020725942163671
        },
        ...
        
###$
