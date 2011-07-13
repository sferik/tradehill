require 'helper'

describe TradeHill do
  describe ".new" do
    it "should return a TradeHill::Client" do
      TradeHill.new.should be_a TradeHill::Client
    end
  end

  describe ".configure" do
    it "should set 'username' and 'password'" do
      TradeHill.configure do |config|
        config.username = "username"
        config.password = "password"
      end

      TradeHill.username.should == "username"
      TradeHill.password.should == "password"
    end
  end
end
