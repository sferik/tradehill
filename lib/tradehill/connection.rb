require 'faraday'
require 'faraday/request/url_encoded'
require 'faraday/response/raise_tradehill_error'
require 'faraday/response/raise_error'
require 'faraday_middleware'
require 'faraday_middleware/response/parse_json'
require 'tradehill/version'

module TradeHill
  module Connection
    private

    def connection(options={})
      options = {
         :headers  => {
           :user_agent => "tradehill gem #{TradeHill::Version}",
         },
        :ssl => {:verify => false},
        :url => 'https://api.tradehill.com',
      }.merge(options)

      Faraday.new(options) do |connection|
        connection.use Faraday::Request::UrlEncoded
        connection.use Faraday::Response::RaiseTradeHillError
        connection.use Faraday::Response::RaiseError
        connection.use FaradayMiddleware::ParseJson
        connection.adapter(Faraday.default_adapter)
      end
    end
  end
end
