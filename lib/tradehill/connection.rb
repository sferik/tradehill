require 'faraday_middleware'

module TradeHill
  module Connection
    private

    def connection(options={})
      options = {
        :ssl => {:verify => false},
        :url => 'https://api.tradehill.com',
      }.merge(options)

      Faraday.new(options) do |connection|
        connection.use Faraday::Request::UrlEncoded
        connection.use Faraday::Response::RaiseError
        connection.use Faraday::Response::Rashify
        connection.use Faraday::Response::ParseJson
        connection.adapter(Faraday.default_adapter)
      end
    end
  end
end
