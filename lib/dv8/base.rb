module Dv8
  module Base
    extend ActiveSupport::Concern

    included do
      attr_reader :using_cfind
      class << self
        alias_method_chain :inherited, :cfind
      end
    end

    module ClassMethods
      def inherited_with_cfind(base)
        base.send(:include, ::Dv8::DescendantDecorator) unless base.abstract_class?
        inherited_without_cfind(base)
      end
    end

    def method_missing(method_name, *args, &block)
      if belongs_to = cached_belongs_to?(method_name)
        with_cfind do
          send(belongs_to, *args)
        end
      else
        super
      end
    end

    def respond_to?(method_name, include_private = false)
      super || cached_belongs_to?(method_name)
    end 

    protected

    def cached_belongs_to?(method_name)
      return false unless method_name.to_s =~ /^cached_(.+)$/
      self.class.reflect_on_all_associations(:belongs_to).each do |assoc|
        return $1 if $1 == assoc.name.to_s
      end
      false
    end

    def with_cfind
      @using_cfind = true
      yield
    ensure
      @using_cfind = false
    end
  end
end