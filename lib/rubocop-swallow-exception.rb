require 'rubocop'

require 'rubocop/swallow_exception'
require 'rubocop/swallow_exception/version'
require 'rubocop/swallow_exception/inject'

RuboCop::SwallowException::Inject.defaults!

require 'rubocop/cop/swallow_exception/swallow_exception'
