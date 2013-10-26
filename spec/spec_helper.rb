GEM_ROOT = File.expand_path("../../", __FILE__)
$:.unshift(File.join(GEM_ROOT, "lib"))

if ENV["TRAVIS"]
  require "coveralls"
  Coveralls.wear!
end

require "irc-notify"
