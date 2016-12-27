require 'simplecov'
SimpleCov.start

ENV['RAILS_ENV'] ||= 'test'
require_relative File.join('dummy_rails_app', 'config', 'environment')

def descendant_count_of(clazz)
  ObjectSpace.each_object(::Class).count { |klass| klass < clazz }
end

def without_rails_root
  old_root = Rails.root.dup
  Rails.define_singleton_method(:root) { nil }
  yield
  Rails.define_singleton_method(:root) { old_root }
end
