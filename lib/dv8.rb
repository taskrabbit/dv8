require "dv8/railtie" if defined?(Rails)

module Dv8

  autoload :Association,            'dv8/association'
  autoload :Base,                   'dv8/base'
  autoload :CanDv8,                 'dv8/can_dv8'
  autoload :DescendantDecorator,    'dv8/descendant_decorator'
  autoload :ScopeMethods,           'dv8/scope_methods'
  autoload :VERSION,                'dv8/version'


  class << self
    def hook!
      ActiveRecord::Base.send(:include, Dv8::Base)
      ActiveRecord::Associations::SingularAssociation.send(:include, Dv8::Association)
    end
  end
end
