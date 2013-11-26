require File.join(File.dirname(__FILE__), '../lib', 'bollinger_band')
require File.join(File.dirname(__FILE__), '../lib', 'stock')

describe "BollingerBand" do
  it "should output stuff" do
    s = BollingerBand.new "goog"
    output = s.bollinger_bands
    output.should_not be_nil
  end
end