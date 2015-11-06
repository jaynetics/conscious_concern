# encoding: utf-8
Gem::Specification.new do |s|
  s.platform    = Gem::Platform::RUBY
  s.name        = 'conscious_concern'
  s.version     = '1.0.0'
  s.license     = 'MIT'

  s.summary     = 'Enhances ActiveSupport::Concern'
  s.description = 'ConsciousConcern is a decorator for ActiveSupport::Concern'\
                  'that adds several metaprogramming features.'

  s.authors     = ['Janosch Müller']
  s.email       = ['janosch84@gmail.com']
  s.homepage    = 'https://github.com/janosch-x/conscious_concern'

  s.files       = Dir[File.join('lib', '**', '*.rb')]

  s.add_dependency 'activesupport', '~> 4'
end
