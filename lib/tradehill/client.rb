require 'tradehill/ask'
require 'tradehill/bid'
require 'tradehill/buy'
require 'tradehill/sell'
require 'tradehill/ticker'
require 'tradehill/trade'
require 'tradehill/configuration'
require 'tradehill/connection'
require 'tradehill/max_bid'
require 'tradehill/min_ask'
require 'tradehill/request'

module TradeHill
  class Client
    include TradeHill::Connection
    include TradeHill::Request
    attr_accessor *Configuration::VALID_OPTIONS_KEYS

    ORDER_TYPES = {:sell => 1, :buy => 2}

    def initialize(options={})
      options = TradeHill.options.merge(options)
      Configuration::VALID_OPTIONS_KEYS.each do |key|
        send("#{key}=", options[key])
      end
    end

    # Fetch the latest ticker data
    #
    # @return [Hashie::Rash]
    # @example
    #   TradeHill.ticker
    def ticker
      ticker = get('Ticker')['ticker']
      Ticker.instance.buy    = ticker['buy'].to_f
      Ticker.instance.high   = ticker['high'].to_f
      Ticker.instance.price  = ticker['last'].to_f
      Ticker.instance.low    = ticker['low'].to_f
      Ticker.instance.sell   = ticker['sell'].to_f
      Ticker.instance.volume = ticker['vol'].to_f
      Ticker.instance
    end

    # Fetch both bids and asks in one call, for network efficiency
    #
    # @return [Hash] with keys :asks and :bids, which contain arrays as described in {TradeHill::Client#asks} and {TradeHill::Client#bids}
    # @example
    #   TradeHill.offers
    def offers
      offers = get('Orderbook')
      asks = offers['asks'].sort_by do |ask|
        ask[0].to_f
      end.map! do |ask|
        Ask.new(*ask)
      end
      bids = offers['bids'].sort_by do |bid|
        -bid[0].to_f
      end.map! do |bid|
        Bid.new(*bid)
      end
      {:asks => asks, :bids => bids}
    end

    # Fetch open asks
    #
    # @return [Array<TradeHill::Ask>] an array of open asks, sorted in price ascending order
    # @example
    #   TradeHill.asks
    def asks
      offers[:asks]
    end

    # Fetch open bids
    #
    # @return [Array<TradeHill::Bid>] an array of open bids, sorted in price descending order
    # @example
    #   TradeHill.bids
    def bids
      offers[:bids]
    end

    # Fetch the lowest priced ask
    #
    # @authenticated false
    # @return [TradeHill::MinAsk]
    # @example
    #   TradeHill.min_ask
    def min_ask
      min_ask = asks.first
      MinAsk.instance.price = min_ask.price
      MinAsk.instance.amount = min_ask.amount
      MinAsk.instance
    end

    # Fetch the highest priced bid
    #
    # @authenticated false
    # @return [TradeHill::MinBid]
    # @example
    #   TradeHill.max_bid
    def max_bid
      max_bid = bids.first
      MaxBid.instance.price = max_bid.price
      MaxBid.instance.amount = max_bid.amount
      MaxBid.instance
    end

    # Fetch recent trades
    #
    # @return [Array<TradeHill::Trade>] an array of trades, sorted in chronological order
    # @example
    #   TradeHill.trades
    def trades
      get('Trades').sort_by{|trade| trade['date']}.map do |trade|
        Trade.new(trade)
      end
    end

    # Fetch your current balance
    #
    # @return [Hashie::Rash]
    # @example
    #   TradeHill.balance
    def balance
      balance = post('GetBalance', pass_params)
      balance['BTC'] = balance['BTC'].to_f
      balance['BTC_Available'] = balance['BTC_Available'].to_f
      balance['BTC_Reserved'] = balance['BTC_Reserved'].to_f
      balance['USD'] = balance['USD'].to_f
      balance['USD_Available'] = balance['USD_Available'].to_f
      balance['USD_Reserved'] = balance['USD_Reserved'].to_f
      balance
    end

    # Fetch a list of open orders
    #
    # @return [Hash] with keys :buys and :sells, which contain arrays as described in {TradeHill::Client#buys} and {TradeHill::Client#sells}
    # @example
    #   TradeHill.orders
    def orders
      parse_orders(post('GetOrders', pass_params)['orders'])
    end

    # Fetch your open buys
    #
    # @return [Array<TradeHill::Buy>] an array of your open bids, sorted by date
    # @example
    #   TradeHill.buys
    def buys
      orders[:buys]
    end

    # Fetch your open sells
    #
    # @return [Array<TradeHill::Sell>] an array of your open asks, sorted by date
    # @example
    #   TradeHill.sells
    def sells
      orders[:sells]
    end

    # Place a limit order to buy BTC
    #
    # @param amount [Numeric] the number of bitcoins to purchase
    # @param price [Numeric] the bid price in US dollars
    # @return [Hash] with keys :buys and :sells, which contain arrays as described in {TradeHill::Client#buys} and {TradeHill::Client#sells}
    # @example
    #   # Buy one bitcoin for $0.011
    #   TradeHill.buy! 1.0, 0.011
    def buy!(amount, price)
      parse_orders(post('BuyBTC', pass_params.merge({:amount => amount, :price => price}))['orders'])
    end

    # Place a limit order to sell BTC
    #
    # @param amount [Numeric] the number of bitcoins to sell
    # @param price [Numeric] the ask price in US dollars
    # @return [Hash] with keys :buys and :sells, which contain arrays as described in {TradeHill::Client#buys} and {TradeHill::Client#sells}
    # @example
    #   # Sell one bitcoin for $100
    #   TradeHill.sell! 1.0, 100.0
    def sell!(amount, price)
      parse_orders(post('SellBTC', pass_params.merge({:amount => amount, :price => price}))['orders'])
    end

    # Cancel an open order
    #
    # @overload cancel(oid)
    #   @param oid [String] an order ID
    #   @return [Hash] with keys :buys and :sells, which contain arrays as described in {TradeHill::Client#buys} and {TradeHill::Client#sells}
    #   @example
    #     my_order = TradeHill.orders.first
    #     TradeHill.cancel my_order.oid
    #     TradeHill.cancel 1234567890
    # @overload cancel(order)
    #   @param order [Hash] a hash-like object, with keys `oid` - the order ID of the transaction to cancel and `type` - the type
    #   @return [Hash] with keys :buys and :sells, which contain arrays as described in {TradeHill::Client#buys} and {TradeHill::Client#sells}
    #   @example
    #     my_order = TradeHill.orders.first
    #     TradeHill.cancel my_order
    #     TradeHill.cancel {"oid" => 1234567890}
    def cancel(args)
      if args.is_a?(Order)
        parse_orders(post('CancelOrder', pass_params.merge(:oid => args.id))['orders'])
      else
        parse_orders(post('CancelOrder', pass_params.merge(:oid => args))['orders'])
      end
    end

    private

    def parse_orders(orders)
      buys = []
      sells = []
      orders.sort_by{|order| order['date']}.each do |order|
        case order['type']
        when ORDER_TYPES[:sell]
          sells << Sell.new(order)
        when ORDER_TYPES[:buy]
          buys << Buy.new(order)
        end
      end
      {:buys => buys, :sells => sells}
    end

    def pass_params
      {:name => username, :pass => password}
    end
  end
end
