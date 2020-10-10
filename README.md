# rubocop-swallow-exception

This is mmj's custom Cop that forbids swallowing exception.
See [OWASP article](https://www.owasp.org/index.php/Exception_handling_techniques#Swallowing_Exceptions)
to understand why this Cop is required.


## Installation

Add this line to your application's Gemfile:

```ruby
gem 'rubocop-swallow-exception'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rubocop-swallow-exception

## Usage

Just add require option when you run rubocop.

    $ rubocop --require rubocop-swallow-exception
    
![example using in RubyMine](./rubocop-swallow-exception.png)


## Specification

The Cop searches rescue body that does not contain raise statement in top level
nor `Raven.capture_exception` ([Sentry](https://sentry.io) client) calling

See spec file below in detail.


```ruby
it 'offense: rescue body is empty' do
  expect_offense(<<~RUBY)
    def bad_method
      p :hello
    rescue => e
    ^^^^^^^^^^^ swallow exception found
      # do nothing
    end
  RUBY
end

it 'ok: raise new exception without any condition' do
  expect_no_offenses(<<~RUBY)
    def bad_method
      p :hello
    rescue => e
      log.error 'error occured'
      log.error e.backtrace.join("\n")
      raise e
    end
  RUBY
end

it 'ok: call Raven.capture_exception' do
  expect_no_offenses(<<~RUBY)
    def bad_method
      p :hello
    rescue => e
      Raven.capture_exception(e)
    end
  RUBY
end

it 'offense: logging only' do
  expect_offense(<<~RUBY)
    def bad_method
      p :hello
    rescue => e
    ^^^^^^^^^^^ swallow exception found
      log.error 'error occured'
      log.error e.backtrace.join("\n")
    end
  RUBY
end

it 'offense: just return value' do
  expect_offense(<<~RUBY)
    def verify_token(env)
      token = BEARER_TOKEN_REGEX.match(env['HTTP_AUTHORIZATION'])[1]
    rescue ::JWT::VerificationError => error
    ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ swallow exception found
      3
    end
  RUBY
end

it 'offense: only logging with some method, and just return value' do
  expect_offense(<<~RUBY)
    def verify_token(env)
      token = BEARER_TOKEN_REGEX.match(env['HTTP_AUTHORIZATION'])[1]
    rescue ::JWT::VerificationError => error
    ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ swallow exception found
      write_log(error)
      return_error('token_signature_verification_failed')
    end
  RUBY
end

```


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

