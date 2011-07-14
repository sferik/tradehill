require 'tradehill/price_ticker'
require 'singleton'

module TradeHill
  class Ticker
    include Singleton
    include PriceTicker
    attr_accessor :buy, :sell, :high, :low, :volume
  end
end
