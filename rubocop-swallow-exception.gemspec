# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rubocop/swallow_exception/version'

Gem::Specification.new do |spec|
  
  spec.name          = 'rubocop-swallow-exception'
  spec.version       = RuboCop::SwallowException::VERSION
  spec.authors       = ['ONDA, Takashi']
  spec.email         = ['onda@mmj.ne.jp']

  spec.summary       = %q{custom Cop forbids swallowing exception}
  spec.description   = <<-EOD
    This custom Cop forbids swallowing exception.
    See OWASP article.
    https://www.owasp.org/index.php/Exception_handling_techniques#Swallowing_Exceptions
  EOD
  spec.homepage      = 'https://github.com/mediamaxjapan/rubocop-swallow-exception'
  spec.license       = 'MIT'

  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']
  :www
  spec.add_runtime_dependency 'rubocop'

end
