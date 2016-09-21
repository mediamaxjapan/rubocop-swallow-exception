# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rubocop/swallow/exception/version'

Gem::Specification.new do |spec|
  
  spec.name          = 'rubocop-swallow-exception'
  spec.version       = Rubocop::Swallow::Exception::VERSION
  spec.authors       = ['ONDA, Takashi']
  spec.email         = ['onda@mmj.ne.jp']

  spec.summary       = %q{custom Cop forbids swallowing exception}
  spec.description   = <<-EOD
    This custom Cop forbids swallowing exception.
    See Imamura's article.
    https://confluence.mmj.ne.jp/display/HAN/Do+not+swallow+exceptions
  EOD
  spec.homepage      = 'https://stash.mmj.ne.jp/projects/MMJ/repos/rubocop-swallow-exception/browse'
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
end
