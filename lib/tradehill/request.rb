module TradeHill
  module Request
    def get(path, options={})
      request(:get, path, options)
    end

    def post(path, options={})
      request(:post, path, options)
    end

    private

    def request(method, path, options)
      response = connection.send(method) do |request|
        case method
        when :get
          request.url(qualified_path(path), options)
        when :post
          request.path = qualified_path(path)
          request.body = options unless options.empty?
        end
      end
      response.body
    end

    def qualified_path(path)
      ["APIv#{version}", currency, path].join('/')
    end
  end
end
