[![Build Status](https://travis-ci.org/henrikhodne/irc-notify.png?branch=master)](https://travis-ci.org/henrikhodne/irc-notify)
[![Code Climate](https://codeclimate.com/github/henrikhodne/irc-notify.png)])(https://codeclimate.com/github/henrikhodne/irc-notify)
[![Coverage Status](https://coveralls.io/repos/henrikhodne/irc-notify.png?branch=master)](https://coveralls.io/r/henrikhodne/irc-notify?branch=master)
[![Gem Version](https://badge.fury.io/rb/irc-notify.png)](http://badge.fury.io/rb/irc-notify)

irc-notify
==========

irc-notify is a very small IRC library meant for publishing notifications to
IRC. It's used by [Travis CI](https://travis-ci.org) to publish IRC
notifications.

Basic example
-------------

``` Ruby
require "irc-notify"
client = IrcNotify::Client.build("irc.example.com", 6697, ssl: true)

client.register("nick")
client.notify("#channel", "Hello, world!")
client.quit
```

Installation
------------

    $ gem install irc-notify
