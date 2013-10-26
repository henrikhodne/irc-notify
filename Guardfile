guard "bundler" do
  watch("Gemfile")
  watch(/^.+\.gemspec/)
end

guard :rspec, cli: "-fs --color --order rand" do
  watch(%r{^spec/.+_spec\.rb$})
  watch(%r{^lib/irc-notify/(.+)\.rb$}) { |m| "spec/#{m[1]}_spec.rb" }
  watch("spec/spec_helper.rb") { "spec" }
end
