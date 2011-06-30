require 'tradehill/configuration'
require 'tradehill/connection'
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
      ticker['buy']  = ticker['buy'].to_f
      ticker['high'] = ticker['high'].to_f
      ticker['last'] = ticker['last'].to_f
      ticker['low']  = ticker['low'].to_f
      ticker['sell'] = ticker['sell'].to_f
      ticker['vol']  = ticker['vol'].to_i
      ticker
    end

    # Fetch both bids and asks in one call, for network efficiency
    #
    # @return [Hashie::Rash]
    # @example
    #   TradeHill.offers
    def offers
      offers = get('Orderbook')
      offers['asks'].each do |o|
        o[0] = o[0].to_f
        o[1] = o[1].to_f
      end
      offers['bids'].each do |o|
        o[0] = o[0].to_f
        o[1] = o[1].to_f
      end
      offers
    end

    # Fetch open asks
    #
    # @return [Array<Numeric>]
    # @example
    #   TradeHill.asks
    def asks
      offers['asks']
    end

    # Fetch open bids
    #
    # @return [Array<Numeric>]
    # @example
    #   TradeHill.bids
    def bids
      offers['bids']
    end

    # Fetch recent trades
    #
    # @return [Array<Hashie::Rash>]
    # @example
    #   TradeHill.trades
    def trades
      get('Trades').each do |t|
        t['amount'] = t['amount'].to_f
        t['date'] = Time.at(t['date'].to_i)
        t['price'] = t['price'].to_f
      end
    end

    # Fetch your balance
    #
    # @return [Hashie::Rash]
    # @example
    #   TradeHill.balance
    def balance
      balance = post('GetBalance', pass_params)
      balance['BTC'] = balance['BTC'].to_f
      balance['USD'] = balance['USD'].to_f
      balance
    end

    # Fetch a list of open orders
    #
    # @return [<Hashie::Rash>]
    # @example
    #   TradeHill.orders
    def orders
      parse_orders(post('GetOrders', pass_params)['orders'])
    end

    # Fetch your open buys
    #
    # @return [Array<Hashie::Rash>]
    # @example
    #   TradeHill.buys
    def buys
      orders.select do |o|
        o['type'] == ORDER_TYPES[:buy]
      end
    end

    # Fetch your open sells
    #
    # @return [Array<Hashie::Rash>]
    # @example
    #   TradeHill.sells
    def sells
      orders.select do |o|
        o['type'] == ORDER_TYPES[:sell]
      end
    end

    # Place a limit order to buy BTC
    #
    # @param amount [Numeric] the number of bitcoins to purchase
    # @param price [Numeric] the bid price in US dollars
    # @return [Array<Hashie::Rash>]
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
    # @return [Array<Hashie::Rash>]
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
    #   @return Array<Hashie::Rash>
    #   @example
    #     my_order = TradeHill.orders.first
    #     TradeHill.cancel my_order.oid
    #     TradeHill.cancel 1234567890
    # @overload cancel(order)
    #   @param order [Hash] a hash-like object, with keys `oid` - the order ID of the transaction to cancel and `type` - the type
    #   @return Array<Hashie::Rash>
    #   @example
    #     my_order = TradeHill.orders.first
    #     TradeHill.cancel my_order
    #     TradeHill.cancel {"oid" => 1234567890}
    def cancel(args)
      if args.is_a?(Hash)
        order = args.delete_if{|k, v| 'oid' != k.to_s}
        parse_orders(post('CancelOrder', pass_params.merge(order))['orders'])
      else
        parse_orders(post('CancelOrder', pass_params.merge(:oid => args))['orders'])
      end
    end

    private

    def parse_orders(orders)
      orders.each do |o|
        o['amount'] = o['amount'].to_f
        o['date'] = Time.at(o['date'])
        o['price'] = o['price'].to_f
        o['reserved_amount'] = o['reserved_amount'].to_f
      end
    end

    def pass_params
      {:name => name, :pass => pass}
    end
  end
end
