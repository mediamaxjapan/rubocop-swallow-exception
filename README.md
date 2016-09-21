# rubocop-swallow-exception

This is mmj's custom Cop that forbids swallowing exception.
See [imamura's article](https://confluence.mmj.ne.jp/display/HAN/Do+not+swallow+exceptions)
to understand why this Cop is required.


## Installation

Add this line to your application's Gemfile:

```ruby
source 'https://www.mmj.ne.jp/gems'
gem 'rubocop-swallow-exception'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rubocop-swallow-exception

## Usage

Just add require option when you run rubocop.

    $ rubocop --require rubocop-swallow-exception


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

