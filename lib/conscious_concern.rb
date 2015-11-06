#
# Decorates ActiveSupport::Concern
#
module ConsciousConcern
  require_relative File.join('conscious_concern', 'eager_loader')
  require 'active_support/concern'
  include ActiveSupport::Concern

  def self.load_classes(*custom_dirs)
    ConsciousConcern::EagerLoader.load_classes_in_rails_dir('controllers')
    ConsciousConcern::EagerLoader.load_classes_in_rails_dir('models')
    custom_dirs.each { |dir| EagerLoader.load_classes_in_dir(dir) }
    extenders.each { |concern| concern._classes_loaded_callbacks.each(&:call) }
  end

  def self.extenders
    @extenders ||= []
  end

  def self.extended(base)
    extenders << base
    ActiveSupport::Concern.extended(base)
  end

  def included(base = nil, &block)
    _classes << base if base && base.is_a?(Class)
    super
  end

  def prepended(base = nil)
    _classes << base if base && base.is_a?(Class)
    super
  end

  # underscore aliases protect core functionality against overrides in extenders

  def classes
    @_classes ||= []
  end
  alias_method :_classes, :classes

  def controllers
    return _classes unless _model_concern?
    _classes.map { |m| _try_constant("#{m.to_s.pluralize}Controller") }.compact
  end
  alias_method :_controllers, :controllers

  def models
    return _classes if _model_concern?
    _classes.map { |ctr| _try_constant(ctr.controller_name) }.compact
  end
  alias_method :_models, :models

  def resources(options = { only: [] }, &resource_routing_block)
    resource_args = _tables
    app_routes_block = resource_routing_block.binding.eval('self')
    app_routes_block.instance_eval do
      resources(*resource_args, options, &resource_routing_block)
    end
  end

  def tables
    _models.map { |model| model.try(:table_name) }.compact
  end
  alias_method :_tables, :tables

  def let_controllers(method_args_hash)
    _classes_loaded_callbacks << proc do
      method_args_hash.each do |method, args|
        _controllers.each { |ctr| ctr.send(method, *args) }
      end
    end
  end

  def classes_loaded_callbacks
    @_classes_loaded_callbacks ||= []
  end
  alias_method :_classes_loaded_callbacks, :classes_loaded_callbacks

  private

  def _model_concern?
    _classes.any? && !_classes.first.to_s.end_with?('Controller')
  end

  def _try_constant(name)
    Object.const_defined?(name.classify) ? name.classify.constantize : nil
  end
end
