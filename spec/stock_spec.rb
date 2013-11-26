require File.join(File.dirname(__FILE__), '../lib', 'stock')

describe "Stock" do
  it "should output stuff" do
    s = Stock.new "goog"
    s.ask.should > 0
  end
end