require "dv8/railtie" if defined?(Rails)

module Dv8

  autoload :Base,                   'dv8/base'
  autoload :CanDv8,                 'dv8/can_dv8'
  autoload :DescendantDecorator,    'dv8/descendant_decorator'
  autoload :HasOneAssociation,      'dv8/has_one_association'
  autoload :ScopeMethods,           'dv8/scope_methods'
  autoload :VERSION,                'dv8/version'


  class << self
    def hook!
      ActiveRecord::Base.send(:include, Dv8::Base)
      ActiveRecord::Associations::HasOneAssociation.send(:include, Dv8::HasOneAssociation)
    end
  end
end
