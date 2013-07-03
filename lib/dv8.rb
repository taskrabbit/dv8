require "dv8/railtie" if defined?(Rails)

module Dv8

  autoload :AlwaysCache,            'dv8/always_cache'
  autoload :Base,                   'dv8/base'
  autoload :CanDv8,                 'dv8/can_dv8'
  autoload :HasOneAssociation,      'dv8/has_one_association'
  autoload :ScopeMethods,           'dv8/scope_methods'
  autoload :VERSION,                'dv8/version'


  class << self
    def hook!
      ActiveRecord::Associations::HasOneAssociation.send(:include, Dv8::HasOneAssociation)
    end
  end
end
