require_relative '../lib/bollinger_bands.rb'
require_relative '../lib/stock.rb'

describe "Stock" do
  it "should output stuff" do
    s = Stock.new "goog"
    output = s.bollinger_bands
    output.should_not be_nil
  end
end