require 'faraday'

module Faraday
  class Response::RaiseTradeHillError < Response::Middleware
    def on_complete(env)
      if 200 == env[:status] && env[:body].is_a?(Hash) && env[:body][:error]
        raise TradeHill::Error, env[:body][:error]
      end
    end
  end
end

