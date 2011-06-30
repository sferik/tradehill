require 'helper'

describe TradeHill::Client do
  %w(ARS AUD BTC BRL CAD CHF CLP CNY CZK DKK EUR GBP HKD ILS INR JPY LR MXN NZD NOK PEN PLN SGD ZAR SEK USD).each do |currency|
    context "with currency #{currency}" do
      before do
        TradeHill.configure do |config|
          config.currency = currency
          config.name     = "my_name"
          config.pass     = "my_password"
        end
        @client = TradeHill::Client.new
      end

      describe '#ticker' do
        before do
          stub_get("/APIv1/#{currency}/Ticker").
            to_return(:status => 200, :body => fixture('ticker.json'))
        end

        it "should fetch the latest ticker data" do
          ticker = @client.ticker
          a_get("/APIv1/#{currency}/Ticker").should have_been_made
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
          stub_get("/APIv1/#{currency}/Orderbook").
            to_return(:status => 200, :body => fixture('orderbook.json'))
        end

        it "should fetch open asks" do
          asks = @client.asks
          a_get("/APIv1/#{currency}/Orderbook").should have_been_made
          asks.last.should == [30.0, 1.0]
        end
      end

      describe '#bids' do
        before do
          stub_get("/APIv1/#{currency}/Orderbook").
            to_return(:status => 200, :body => fixture('orderbook.json'))
        end

        it "should fetch open bids" do
          bids = @client.bids
          a_get("/APIv1/#{currency}/Orderbook").should have_been_made
          bids.last.should == [18.5, 75.0]
        end
      end

      describe '#offers' do
        before do
          stub_get("/APIv1/#{currency}/Orderbook").
            to_return(:status => 200, :body => fixture('orderbook.json'))
        end

        it "should fetch both bids and asks in one call" do
          offers = @client.offers
          a_get("/APIv1/#{currency}/Orderbook").should have_been_made.once
          offers.asks.last.should == [30.0, 1.0]
          offers.bids.last.should == [18.5, 75.0]
        end
      end

      describe '#trades' do
        before do
          stub_get("/APIv1/#{currency}/Trades").
            to_return(:status => 200, :body => fixture('trades.json'))
        end

        it "should fetch trades" do
          trades = @client.trades
          a_get("/APIv1/#{currency}/Trades").should have_been_made
          trades.last.date.should == Time.utc(2011, 6, 16, 19, 07, 54)
          trades.last.price.should == 19.25
          trades.last.amount.should == 0.15
          trades.last.tid.should == "4251"
        end
      end

      describe '#balance' do
        before do
          stub_post("/APIv1/#{currency}/GetBalance").
            to_return(:status => 200, :body => fixture('balance.json'))
        end

        it "should fetch balance" do
          balance = @client.balance
          a_post("/APIv1/#{currency}/GetBalance").should have_been_made
          balance.usd.should == 1000.0
          balance.btc.should == 1000.0
        end
      end

      describe "order methods" do
        before :each do
          stub_post("/APIv1/#{currency}/GetOrders").
            to_return(:status => 200, :body => fixture('orders.json'))
        end

        describe "buys" do
          it "should fetch orders" do
            buys = @client.buys
            a_post("/APIv1/#{currency}/GetOrders").should have_been_made
            buys.last.price.should == 0.011
          end
        end

        describe "sells" do
          it "should fetch sells" do
            sells = @client.sells
            a_post("/APIv1/#{currency}/GetOrders").should have_been_made
            sells.last.price.should == 30
          end
        end

        describe "orders" do
          it "should fetch both buys and sells, with only one call" do
            orders = @client.orders
            a_post("/APIv1/#{currency}/GetOrders").should have_been_made.once
            orders.last.price.should == 30
          end
        end
      end

      describe "buy!" do
        before do
          stub_post("/APIv1/#{currency}/BuyBTC").
            to_return(:status => 200, :body => fixture('orders.json'))
        end

        it "should place a bid" do
          @client.buy!(0.88, 0.89)
          a_post("/APIv1/#{currency}/BuyBTC").
            with(:body => {"name" => "my_name", "pass" => "my_password", "amount" => "0.88", "price" => "0.89"}).
            should have_been_made
        end
      end

      describe "sell!" do
        before do
          stub_post("/APIv1/#{currency}/SellBTC").
            to_return(:status => 200, :body => fixture('orders.json'))
        end

        it "should place an ask" do
          @client.sell!(0.88, 89.0)
          a_post("/APIv1/#{currency}/SellBTC").
            with(:body => {"name" => "my_name", "pass" => "my_password", "amount" => "0.88", "price" => "89.0"}).
            should have_been_made
        end
      end

      describe "cancel" do
        before do
          stub_post("/APIv1/#{currency}/CancelOrder").
            with(:body => {"name" => "my_name", "pass" => "my_password", "oid" => "3166"}).
            to_return(:status => 200, :body => fixture('orders.json'))
        end

        context "with an oid passed" do
          it "should cancel an order" do
            @client.cancel(3166)
            a_post("/APIv1/#{currency}/CancelOrder").
              with(:body => {"name" => "my_name", "pass" => "my_password", "oid" => "3166"}).
              should have_been_made
          end
        end

        context "with an order passed" do
          it "should cancel an order" do
            @client.cancel({'oid' => "3166"})
            a_post("/APIv1/#{currency}/CancelOrder").
              with(:body => {"name" => "my_name", "pass" => "my_password", "oid" => "3166"}).
              should have_been_made
          end
        end
      end
    end
  end
end
