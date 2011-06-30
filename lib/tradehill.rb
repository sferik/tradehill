require 'tradehill/client'
require 'tradehill/configuration'

module TradeHill
  extend Configuration
  class << self
    # Alias for TradeHill::Client.new
    #
    # @return [TradeHill::Client]
    def new
      TradeHill::Client.new
    end

    # Delegate to TradeHill::Client
    def method_missing(method, *args, &block)
      return super unless new.respond_to?(method)
      new.send(method, *args, &block)
    end

    def respond_to?(method, include_private=false)
      new.respond_to?(method, include_private) || super(method, include_private)
    end
  end
end
