module Dv8
  module Base
    extend ActiveSupport::Concern

    included do
      include ::Dv8::CanDv8

      class << self
        alias_method_chain :inherited, :dv8
      end
    end

    module ClassMethods
      def inherited_with_dv8(base)
        base.send(:include, ::Dv8::DescendantDecorator) unless base.abstract_class?
        inherited_without_dv8(base)
      end
    end

    def method_missing(method_name, *args, &block)
      reflection = dv8_association(method_name)
      if reflection
        if reflection.collection?
          send(reflection.name, *args, &block).cached
        else
          self.dv8! do
            assoc = send(reflection.name, *args, &block)
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