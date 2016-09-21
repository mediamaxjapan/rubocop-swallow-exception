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

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  # if spec.respond_to?(:metadata)
  #   spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  # else
  #   raise 'RubyGems 2.0 or newer is required to protect against public gem pushes.'
  # end

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.13'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'

  spec.add_runtime_dependency('rubocop', '~> 0.43')

end
