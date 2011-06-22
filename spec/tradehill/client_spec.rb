require 'helper'

describe TradeHill::Client do
  before do
    @client = TradeHill::Client.new
  end

  describe '#asks' do
    before do
      stub_get('/APIv1/USD/Orderbook').
        to_return(:status => 200, :body => fixture('orderbook.json'))
    end

    it "should fetch open asks" do
      asks = @client.asks
      a_get('/APIv1/USD/Orderbook').should have_been_made
      asks.last.should == [30.0, 1.0]
    end
  end

  describe '#bids' do
    before do
      stub_get('/APIv1/USD/Orderbook').
        to_return(:status => 200, :body => fixture('orderbook.json'))
    end

    it "should fetch open bids" do
      bids = @client.bids
      a_get('/APIv1/USD/Orderbook').should have_been_made
      bids.last.should == [18.5, 75.0]
    end
  end

  describe '#trades' do
    before do
      stub_get('/APIv1/USD/Trades').
        to_return(:status => 200, :body => fixture('trades.json'))
    end

    it "should fetch trades" do
      trades = @client.trades
      a_get('/APIv1/USD/Trades').should have_been_made
      trades.last.date.should == Time.utc(2011, 6, 16, 19, 07, 54)
      trades.last.price.should == 19.25
      trades.last.amount.should == 0.15
      trades.last.tid.should == "4251"
    end
  end
end
