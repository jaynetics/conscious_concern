# encoding: utf-8
Gem::Specification.new do |s|
  s.platform    = Gem::Platform::RUBY
  s.name        = 'conscious_concern'
  s.version     = '1.0.6'
  s.license     = 'MIT'

  s.summary     = 'Enhances ActiveSupport::Concern'
  s.description = 'ConsciousConcern is a decorator for ActiveSupport::Concern '\
                  'that adds several metaprogramming features.'

  s.authors     = ['Janosch Müller']
  s.email       = ['janosch84@gmail.com']
  s.homepage    = 'https://github.com/janosch-x/conscious_concern'

  s.files       = Dir[File.join('lib', '**', '*.rb')]

  s.add_dependency 'activesupport', '~> 5.0'

  s.add_development_dependency 'codeclimate-test-reporter', '~> 1.0'
  s.add_development_dependency 'rails', '~> 5.0'
  s.add_development_dependency 'rake', '~> 11.3'
  s.add_development_dependency 'rspec', '~> 3.5'
  s.add_development_dependency 'rspec-rails', '~> 3.5'
  s.add_development_dependency 'sqlite3', '~> 1.3'
end
