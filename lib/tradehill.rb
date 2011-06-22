require 'tradehill/client'

module TradeHill
  class << self
    attr_accessor :name, :pass
    def configure
      yield self
    end
  end

  # Alias for TradeHill::Client.new
  #
  # @return [TradeHill::Client]
  def self.new
    TradeHill::Client.new
  end

  # Delegate to TradeHill::Client
  def self.method_missing(method, *args, &block)
    return super unless new.respond_to?(method)
    new.send(method, *args, &block)
  end

  def self.respond_to?(method, include_private=false)
    new.respond_to?(method, include_private) || super(method, include_private)
  end
end
