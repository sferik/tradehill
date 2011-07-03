require 'helper'

describe Faraday::Response do
  before do
    stub_get("/APIv1/USD/Trades").
      to_return(:status => 200, :body => fixture('error.json'))
  end

  it "should raise TradeHill::Error" do
    lambda do
      TradeHill.trades
    end.should raise_error(TradeHill::Error)
  end
end
