require 'tradehill/connection'
require 'tradehill/request'

module TradeHill
  class Client
    include TradeHill::Connection
    include TradeHill::Request

    # Fetch the latest ticker data
    #
    # @return [Hashie::Rash]
    # @example
    #   TradeHill.ticker
    def ticker
      ticker = get('/APIv1/USD/Ticker')['ticker']
      ticker['buy']  = ticker['buy'].to_f
      ticker['sell'] = ticker['sell'].to_f
      ticker['high'] = ticker['high'].to_f
      ticker['low']  = ticker['low'].to_f
      ticker['last'] = ticker['last'].to_f
      ticker['vol']  = ticker['vol'].to_i
      ticker
    end

    # Fetch open asks
    #
    # @return [Array<Numeric>]
    # @example
    #   TradeHill.asks
    def asks
      get('/APIv1/USD/Orderbook')['asks'].each do |o|
        o[0] = o[0].to_f
        o[1] = o[1].to_f
      end
    end

    # Fetch open bids
    #
    # @return [Array<Numeric>]
    # @example
    #   TradeHill.bids
    def bids
      get('/APIv1/USD/Orderbook')['bids'].each do |o|
        o[0] = o[0].to_f
        o[1] = o[1].to_f
      end
    end

    # Fetch both bids and asks in one call, for network efficiency
    #
    # @return [Hashie::Rash]
    # @example
    #   TradeHill.offers
    def offers
      offers = get('/APIv1/USD/Orderbook')
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

    # Fetch recent trades
    #
    # @return [Array<Hashie::Rash>]
    # @example
    #   TradeHill.trades
    def trades
      get('/APIv1/USD/Trades').each do |t|
        t['date'] = Time.at(t['date'].to_i)
        t['price'] = t['price'].to_f
        t['amount'] = t['amount'].to_f
      end
    end
  end
end
