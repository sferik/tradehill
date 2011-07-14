require 'helper'

describe TradeHill::Client do
  %w(ARS AUD BTC BRL CAD CHF CLP CNY CZK DKK EUR GBP HKD ILS INR JPY LR MXN NZD NOK PEN PLN SGD ZAR SEK USD).each do |currency|
    context "with currency #{currency}" do
      before do
        TradeHill.configure do |config|
          config.currency = currency
          config.username = "my_name"
          config.password = "my_password"
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
          a_get("/APIv1/#{currency}/Ticker").
            should have_been_made
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
          a_get("/APIv1/#{currency}/Orderbook").
            should have_been_made
          asks.last.price.should == 200.0
          asks.last.eprice.should == 201.08586366378444
          asks.last.amount.should == 19.3
        end
      end

      describe '#bids' do
        before do
          stub_get("/APIv1/#{currency}/Orderbook").
            to_return(:status => 200, :body => fixture('orderbook.json'))
        end

        it "should fetch open bids" do
          bids = @client.bids
          a_get("/APIv1/#{currency}/Orderbook").
            should have_been_made
          bids.last.price.should == 0.01
          bids.last.eprice.should == 0.009946
          bids.last.amount.should == 100000.0
        end
      end

      describe '#offers' do
        before do
          stub_get("/APIv1/#{currency}/Orderbook").
            to_return(:status => 200, :body => fixture('orderbook.json'))
        end

        it "should fetch both bids and asks in one call" do
          offers = @client.offers
          a_get("/APIv1/#{currency}/Orderbook").
            should have_been_made.once
          offers[:asks].last.price.should == 200.0
          offers[:asks].last.eprice.should == 201.08586366378444
          offers[:asks].last.amount.should == 19.3
          offers[:bids].last.price.should == 0.01
          offers[:bids].last.eprice.should == 0.009946
          offers[:bids].last.amount.should == 100000.0
        end
      end

      describe '#min_ask' do
        before do
          stub_get("/APIv1/#{currency}/Orderbook").
            to_return(:status => 200, :body => fixture('orderbook.json'))
        end

        it "should fetch the lowest priced ask" do
          min_ask = @client.min_ask
          a_get("/APIv1/#{currency}/Orderbook").
            should have_been_made.once
          min_ask.price.should == 19.249999
          min_ask.eprice.should == 19.354513372209933
          min_ask.amount.should == 100.0
        end
      end

      describe '#max_bid' do
        before do
          stub_get("/APIv1/#{currency}/Orderbook").
            to_return(:status => 200, :body => fixture('orderbook.json'))
        end

        it "should fetch the highest priced bid" do
          max_bid = @client.max_bid
          a_get("/APIv1/#{currency}/Orderbook").
            should have_been_made.once
          max_bid.price.should == 18.95
          max_bid.eprice.should == 18.84767
          max_bid.amount.should == 2.0
        end
      end

      describe '#trades' do
        before do
          stub_get("/APIv1/#{currency}/Trades").
            to_return(:status => 200, :body => fixture('trades.json'))
        end

        it "should fetch trades" do
          trades = @client.trades
          a_get("/APIv1/#{currency}/Trades").
            should have_been_made
          trades.last.date.should == Time.utc(2011, 6, 16, 19, 07, 54)
          trades.last.price.should == 19.25
          trades.last.amount.should == 0.15
          trades.last.id.should == 4251
        end
      end

      describe '#balance' do
        before do
          stub_post("/APIv1/#{currency}/GetBalance").
            to_return(:status => 200, :body => fixture('balance.json'))
        end

        it "should fetch balance" do
          balance = @client.balance
          a_post("/APIv1/#{currency}/GetBalance").
            should have_been_made
          balance.usd.should == 2.3450318173
          balance.btc.should == 19.8514458363
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
            a_post("/APIv1/#{currency}/GetOrders").
              should have_been_made
            buys.last.price.should == 0.011
            buys.last.date.should == Time.utc(2011, 6, 22, 14, 56, 39)
          end
        end

        describe "sells" do
          it "should fetch sells" do
            sells = @client.sells
            a_post("/APIv1/#{currency}/GetOrders").
              should have_been_made
            sells.last.price.should == 30
            sells.last.date.should == Time.utc(2011, 6, 22, 14, 56, 39)
          end
        end

        describe "orders" do
          it "should fetch both buys and sells, with only one call" do
            orders = @client.orders
            a_post("/APIv1/#{currency}/GetOrders").
              should have_been_made.once
            orders[:buys].last.price.should == 0.011
            orders[:buys].last.date.should == Time.utc(2011, 6, 22, 14, 56, 39)
            orders[:sells].last.price.should == 30
            orders[:sells].last.date.should == Time.utc(2011, 6, 22, 14, 56, 39)
          end
        end
      end

      describe "buy!" do
        before do
          stub_post("/APIv1/#{currency}/BuyBTC").
            to_return(:status => 200, :body => fixture('orders.json'))
        end

        it "should place a bid" do
          buy = @client.buy!(0.88, 0.89)
          a_post("/APIv1/#{currency}/BuyBTC").
            with(:body => {"name" => "my_name", "pass" => "my_password", "amount" => "0.88", "price" => "0.89"}).
            should have_been_made
          buy[:buys].last.price.should == 0.011
          buy[:buys].last.date.should == Time.utc(2011, 6, 22, 14, 56, 39)
          buy[:sells].last.price.should == 30
          buy[:sells].last.date.should == Time.utc(2011, 6, 22, 14, 56, 39)
        end
      end

      describe "sell!" do
        before do
          stub_post("/APIv1/#{currency}/SellBTC").
            to_return(:status => 200, :body => fixture('orders.json'))
        end

        it "should place an ask" do
          sell = @client.sell!(0.88, 89.0)
          a_post("/APIv1/#{currency}/SellBTC").
            with(:body => {"name" => "my_name", "pass" => "my_password", "amount" => "0.88", "price" => "89.0"}).
            should have_been_made
          sell[:buys].last.price.should == 0.011
          sell[:buys].last.date.should == Time.utc(2011, 6, 22, 14, 56, 39)
          sell[:sells].last.price.should == 30
          sell[:sells].last.date.should == Time.utc(2011, 6, 22, 14, 56, 39)
        end
      end

      describe "cancel" do
        before do
          stub_post("/APIv1/#{currency}/GetOrders").
            to_return(:status => 200, :body => fixture('orders.json'))
          stub_post("/APIv1/#{currency}/CancelOrder").
            with(:body => {"name" => "my_name", "pass" => "my_password", "oid" => "3166"}).
            to_return(:status => 200, :body => fixture('orders.json'))
        end

        context "with an oid passed" do
          it "should cancel an order" do
            cancel = @client.cancel(3166)
            a_post("/APIv1/#{currency}/CancelOrder").
              with(:body => {"name" => "my_name", "pass" => "my_password", "oid" => "3166"}).
              should have_been_made
            cancel[:buys].last.price.should == 0.011
            cancel[:buys].last.date.should == Time.utc(2011, 6, 22, 14, 56, 39)
            cancel[:sells].last.price.should == 30
            cancel[:sells].last.date.should == Time.utc(2011, 6, 22, 14, 56, 39)
          end
        end

        context "with an order passed" do
          it "should cancel an order" do
            order = @client.buys.first
            cancel = @client.cancel(order)
            a_post("/APIv1/#{currency}/GetOrders").
              should have_been_made
            a_post("/APIv1/#{currency}/CancelOrder").
              with(:body => {"name" => "my_name", "pass" => "my_password", "oid" => "3166"}).
              should have_been_made
            cancel[:buys].last.price.should == 0.011
            cancel[:buys].last.date.should == Time.utc(2011, 6, 22, 14, 56, 39)
            cancel[:sells].last.price.should == 30
            cancel[:sells].last.date.should == Time.utc(2011, 6, 22, 14, 56, 39)
          end
        end
      end
    end
  end
end
