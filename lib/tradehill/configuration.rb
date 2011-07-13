require 'tradehill/version'

module TradeHill
  module Configuration
    # An array of valid keys in the options hash when configuring a {TradeHill::Client}
    VALID_OPTIONS_KEYS = [
      :commission,
      :currency,
      :password,
      :username,
      :version,
    ]

    DEFAULT_COMMISSION = 0.0054.freeze

    DEFAULT_CURRENCY = "USD".freeze

    DEFAULT_VERSION = "1".freeze

    attr_accessor *VALID_OPTIONS_KEYS

    # When this module is extended, set all configuration options to their default values
    def self.extended(base)
      base.reset
    end

    # Convenience method to allow configuration options to be set in a block
    def configure
      yield self
    end

    # Create a hash of options and their values
    def options
      options = {}
      VALID_OPTIONS_KEYS.each{|k| options[k] = send(k)}
      options
    end

    # Reset all configuration options to defaults
    def reset
      self.commission = DEFAULT_COMMISSION
      self.currency   = DEFAULT_CURRENCY
      self.password   = nil
      self.username   = nil
      self.version    = DEFAULT_VERSION
      self
    end
  end
end
