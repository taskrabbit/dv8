# decorates ActiveRecord::Base
# provides all AR objects with the ability to load associations via the dv8 cache
# propagates dv8 scopes and functionality to descendents via the DescendantDecorator
module Dv8
  module Base
    extend ActiveSupport::Concern

    # AR::Base
    included do
      include ::Dv8::CanDv8

      after_update  :expire_dv8
      after_touch   :expire_dv8

      scope :cached, -> { scoped } do
        include ::Dv8::ScopeMethods
      end

    end


    module ClassMethods
      def cfind(*args)
        self.cached.find(*args)
      end

      def dv8_key(id)
        "#{self.table_name}-#{id}"
      end
    end

    def expire_dv8
      dv8_keys.each do |key|
        Rails.cache.delete(key)
      end
    end

    def dv8_keys
      keys = %w(id friendly_id to_param cached_slug slug).map{|meth| self.respond_to?(meth) ? self.send(meth) : nil }
      keys.compact.uniq.map{|id| self.class.dv8_key(id) }
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

    def respond_to_missing?(method_name, include_private = false)
      super || !!dv8_association(method_name)
    end

    protected

    def dv8_association(method_name)
      return false unless method_name.to_s =~ /^cached_(.+)$/
      self.class.reflect_on_association($1.to_sym)
    end

  end
end
