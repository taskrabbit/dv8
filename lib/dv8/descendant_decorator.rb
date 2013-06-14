module Dv8
  module DescendantDecorator
    extend ActiveSupport::Concern
    
    included do
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
      keys = %w(id friendly_id to_param).map{|meth| respond_to?(meth) ? send(meth) : nil}
      keys.compact.uniq.map{|id| self.class.dv8_key(id) }
    end

  end
end