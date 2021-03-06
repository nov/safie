# Safie

Welcome to your new gem! In this directory, you'll find the files you need to be able to package up your Ruby library into a gem. Put your Ruby code in the file `lib/safie`. To experiment with that code, run `bin/console` for an interactive prompt.

TODO: Delete this and the text above, and describe your gem

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'safie'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install safie

## Usage

```ruby
require 'safie'

client = Safie::Client.new(
  identifier: 'client_id',
  secret: 'client_secret',
  redirect_uri: 'https://client.example.com/callback'
)

authorization_uri = client.authorization_uri(
  state: SecureRandom.hex(8)
)
puts authorization_uri
`open "#{authorization_uri}"`

print 'code: ' and STDOUT.flush
code = gets.chop
client.authorization_code = code
access_token = client.access_token!
access_token.token_info!
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/nov/safie.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
