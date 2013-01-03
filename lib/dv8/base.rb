# decorates ActiveRecord::Base
# provides all AR objects with the ability to load associations via the dv8 cache
# propagates dv8 scopes and functionality to descendents via the DescendantDecorator
module Dv8
  module Base
    extend ActiveSupport::Concern

    # AR::Base
    included do
      include ::Dv8::CanDv8

      class << self
        alias_method_chain :inherited, :dv8
      end
    end

    module ClassMethods

      # apply the descendent decorator to all real AR children
      def inherited_with_dv8(base)
        base.send(:include, ::Dv8::DescendantDecorator) unless base.abstract_class?
        inherited_without_dv8(base)
      end
    end

    # allow access to associations via the dv8 cache.
    # invoke via object.cached_{association_name}
    # for example: company.cached_members or company.cached_owner
    # collections retrieve the ids then do a dv8 lookup for each object.
    def method_missing(method_name, *args, &block)
      reflection = dv8_association(method_name)

      # the association reflection matching the invocation
      if reflection

        # if we're a collection, query the id's then find all the objects
        if reflection.collection?
          ids = send("#{reflection.name.to_s.singularize}_ids", *args, &block)
          reflection.klass.cfind(ids)

        # if we're a belongs_to
        elsif reflection.belongs_to?
          id = send(reflection.foreign_key)
          id ? reflection.klass.cfind(id) : nil
        else
          self.dv8! do
            send(reflection.name, *args, &block)
          end
        end
      else
        super
      end
    end

    def respond_to?(method_name, include_private = false)
      super || !!dv8_association(method_name)
    end 

    protected

    def dv8_association(method_name)
      return false unless method_name.to_s =~ /^cached_(.+)$/
      self.class.reflect_on_association($1.to_sym)
    end

  end
end