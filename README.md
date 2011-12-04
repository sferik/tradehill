# Ruby wrapper for the TradeHill API
TradeHill is a Bitcoin exchange that supports 26 currencies.

## <a name="installation"></a>Installation
    gem install tradehill

## <a name="name"></a>Alias
After installing the gem, you can get the current price for 1 BTC in USD by
typing `btc` in your bash shell simply by setting the following alias:

    alias btc='ruby -r rubygems -r tradehill -e "puts TradeHill.ticker.last"'

## <a name="documentation"></a>Documentation
[http://rdoc.info/gems/tradehill][documentation]

[documentation]: http://rdoc.info/gems/tradehill

## <a name="ci"></a>Continuous Integration
[![Build Status](https://secure.travis-ci.org/sferik/tradehill.png)][ci]

[ci]: http://travis-ci.org/sferik/tradehill

## <a name="dependencies"></a>Dependency Status
[![Dependency Status](https://gemnasium.com/sferik/tradehill.png?travis)][gemnasium]

[gemnasium]: https://gemnasium.com/sferik/tradehill

## <a name="examples"></a>Usage Examples
    require 'rubygems'
    require 'tradehill'

    # Fetch open asks
    puts TradeHill.asks

    # Fetch open bids
    puts TradeHill.bids

    # Fetch recent trades
    puts TradeHill.trades

    # Certain methods require authentication
    TradeHill.configure do |config|
      config.currency = "USD" # This is the default
      config.username = YOUR_TRADEHILL_USERNAME
      config.password = YOUR_TRADEHILL_PASSWORD
    end

    # Fetch your current balance
    puts TradeHill.balance

    # Place a limit order to buy one bitcoin for $0.011
    TradeHill.buy! 1.0, 0.011

    # Place a limit order to sell one bitcoin for $100
    TradeHill.sell! 1.0, 100.0

    # Cancel order 1234567890
    TradeHill.cancel "1234567890"

## <a name="contributing"></a>Contributing
In the spirit of [free software][free-sw], **everyone** is encouraged to help
improve this project.

[free-sw]: http://www.fsf.org/licensing/essays/free-sw.html

Here are some ways *you* can contribute:

* by using alpha, beta, and prerelease versions
* by reporting bugs
* by suggesting new features
* by writing or editing documentation
* by writing specifications
* by writing code (**no patch is too small**: fix typos, add comments, clean up
  inconsistent whitespace)
* by refactoring code
* by closing [issues][]
* by reviewing patches

[issues]: https://github.com/sferik/tradehill/issues

## <a name="issues"></a>Submitting an Issue
We use the [GitHub issue tracker][issues] to track bugs and features. Before
submitting a bug report or feature request, check to make sure it hasn't
already been submitted. You can indicate support for an existing issue by
voting it up. When submitting a bug report, please include a [Gist][] that
includes a stack trace and any details that may be necessary to reproduce the
bug, including your gem version, Ruby version, and operating system. Ideally, a
bug report should include a pull request with failing specs.

[gist]: https://gist.github.com/

## <a name="pulls"></a>Submitting a Pull Request
1. Fork the project.
2. Create a topic branch.
3. Implement your feature or bug fix.
4. Add documentation for your feature or bug fix.
5. Run `bundle exec rake doc:yard`. If your changes are not 100% documented, go
   back to step 4.
6. Add specs for your feature or bug fix.
7. Run `bundle exec rake spec`. If your changes are not 100% covered, go back
   to step 6.
8. Commit and push your changes.
9. Submit a pull request. Please do not include changes to the gemspec,
   version, or history file. (If you want to create your own version for some
   reason, please do so in a separate commit.)

## <a name="versions"></a>Supported Ruby Versions
This library aims to support and is [tested against][ci] the following Ruby
implementations:

* Ruby 1.8.7
* Ruby 1.9.2
* Ruby 1.9.3
* [JRuby][]
* [Rubinius][]
* [Ruby Enterprise Edition][ree]

[jruby]: http://www.jruby.org/
[rubinius]: http://rubini.us/
[ree]: http://www.rubyenterpriseedition.com/

If something doesn't work on one of these interpreters, it should be considered
a bug.

This library may inadvertently work (or seem to work) on other Ruby
implementations, however support will only be provided for the versions listed
above.

If you would like this library to support another Ruby version, you may
volunteer to be a maintainer. Being a maintainer entails making sure all tests
run and pass on that implementation. When something breaks on your
implementation, you will be personally responsible for providing patches in a
timely fashion. If critical issues for a particular implementation exist at the
time of a major release, support for that Ruby version may be dropped.

## <a name="copyright"></a>Copyright
Copyright (c) 2011 Erik Michaels-Ober. See [LICENSE][] for details.

[license]: https://github.com/sferik/tradehill/blob/master/LICENSE.md
