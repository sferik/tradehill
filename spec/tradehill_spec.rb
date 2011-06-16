require 'helper'

describe TradeHill do
  describe ".new" do
    it "should return a TradeHill::Client" do
      TradeHill.new.should be_a TradeHill::Client
    end
  end
end
