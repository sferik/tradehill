# Ruby wrapper for the TradeHill API

TradeHill allows you to trade US Dollars (USD) for Bitcoins (BTC) or Bitcoins
for US Dollars.

Installation
------------
    gem install tradehill

Alias
-----
After installing the gem, you can get the current price for 1 BTC in USD by
typing `btc` in your bash shell simply by setting the following alias:

    alias btc='ruby -r rubygems -r tradehill -e "puts Tradehill.ticker.last"'

Documentation
-------------
[http://rdoc.info/gems/tradehill](http://rdoc.info/gems/tradehill)

Continuous Integration
----------------------
[![Build Status](http://travis-ci.org/sferik/tradehill.png)](http://travis-ci.org/sferik/tradehill)

Usage Examples
--------------
    require 'rubygems'
    require 'tradehill'

    # Fetch open asks
    puts TradeHill.asks

    # Fetch open bids
    puts TradeHill.bids

    # Fetch the last 48 hours worth of trades (takes a minute)
    puts TradeHill.trades

Contributing
------------
In the spirit of [free
software](http://www.fsf.org/licensing/essays/free-sw.html), **everyone** is
encouraged to help improve this project.

Here are some ways *you* can contribute:

* by using alpha, beta, and prerelease versions
* by reporting bugs
* by suggesting new features
* by writing or editing documentation
* by writing specifications
* by writing code (**no patch is too small**: fix typos, add comments, clean up
  inconsistent whitespace)
* by refactoring code
* by closing [issues](https://github.com/sferik/tradehill/issues)
* by reviewing patches
* by financially (please send bitcoin donations to
  1KxSo9bGBfPVFEtWNLpnUK1bfLNNT4q31L)

Submitting an Issue
-------------------
We use the [GitHub issue tracker](https://github.com/sferik/tradehill/issues) to
track bugs and features. Before submitting a bug report or feature request,
check to make sure it hasn't already been submitted. You can indicate support
for an existing issuse by voting it up. When submitting a bug report, please
include a [Gist](https://gist.github.com/) that includes a stack trace and any
details that may be necessary to reproduce the bug, including your gem version,
Ruby version, and operating system. Ideally, a bug report should include a pull
request with failing specs.

Submitting a Pull Request
-------------------------
1. Fork the project.
2. Create a topic branch.
3. Implement your feature or bug fix.
4. Add documentation for your feature or bug fix.
5. Run <tt>bundle exec rake doc:yard</tt>. If your changes are not 100%
   documented, go back to step 4.
6. Add specs for your feature or bug fix.
7. Run <tt>bundle exec rake spec</tt>. If your changes are not 100% covered, go
   back to step 6.
8. Commit and push your changes.
9. Submit a pull request. Please do not include changes to the gemspec,
   version, or history file. (If you want to create your own version for some
   reason, please do so in a separate commit.)

Copyright
---------
Copyright (c) 2011 Erik Michaels-Ober.
See [LICENSE](https://github.com/sferik/tradehill/blob/master/LICENSE.md) for details.
