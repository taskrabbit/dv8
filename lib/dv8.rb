require "dv8/railtie" if defined?(Rails)

module Dv8
  autoload :Base,                   'dv8/base'
  autoload :BelongsTo,              'dv8/belongs_to'
  autoload :BelongsToPolymorphic,   'dv8/belongs_to_polymorphic'
  autoload :DescendentDecorator,    'dv8/descendent_decorator'
  autoload :ScopeMethods,           'dv8/scope_methods'
  autoload :VERSION,                'dv8/version'
end
