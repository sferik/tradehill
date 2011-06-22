require 'helper'

describe TradeHill::Client do
  before do
    @client = TradeHill::Client.new
  end

  describe '#ticker' do
    before do
      stub_get('/APIv1/USD/Ticker').
        to_return(:status => 200, :body => fixture('ticker.json'))
    end

    it "should fetch the latest ticker data" do
      ticker = @client.ticker
      a_get('/APIv1/USD/Ticker').should have_been_made
      ticker.buy.should  == 12.62000002
      ticker.sell.should == 12.7
      ticker.high.should == 0.0
      ticker.low.should  == 0.0
      ticker.last.should == 12.68
      ticker.vol.should  == 0
    end
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

  describe '#offers' do
    before do
      stub_get('/APIv1/USD/Orderbook').
        to_return(:status => 200, :body => fixture('orderbook.json'))
    end

    it "should fetch both bids and asks in one call" do
      offers = @client.offers
      a_get('/APIv1/USD/Orderbook').should have_been_made.once
      offers.asks.last.should == [30.0, 1.0]
      offers.bids.last.should == [18.5, 75.0]
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
