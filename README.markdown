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
