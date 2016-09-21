require 'rubocop'
require 'rubocop/swallow_exception/version'
require 'rubocop/swallow_exception/cop/lint/swallow_exception'
require 'rubocop/swallow_exception/inject'

RuboCop::SwallowException::Inject.defaults!
