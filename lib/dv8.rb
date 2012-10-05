require "dv8/railtie" if defined?(Rails)

module Dv8
  autoload :Base,                   'dv8/base'
  autoload :BelongsTo,              'dv8/belongs_to'
  autoload :BelongsToPolymorphic,   'dv8/belongs_to_polymorphic'
  autoload :DescendantDecorator,    'dv8/descendant_decorator'
  autoload :ScopeMethods,           'dv8/scope_methods'
  autoload :SingularAssociation,    'dv8/singular_association'
  autoload :VERSION,                'dv8/version'


  class << self
    def hook!
      ActiveRecord::Base.send(:include, Dv8::Base)
      if defined?(ActiveRecord::Associations::SingularAssociation)
        ActiveRecord::Associations::SingularAssociation.send(:include, Dv8::SingularAssociation)
      else
        ActiveRecord::Associations::BelongsToAssociation.send(:include, Dv8::BelongsTo)        
        ActiveRecord::Associations::BelongsToPolymorphicAssociation.send(:include, Dv8::BelongsToPolymorphic)
      end
    end
  end
end
