module Dv8
  module DescendantDecorator
    extend ActiveSupport::Concern
    
    included do
      after_update  :expire_dv8
      after_touch   :expire_dv8

      scope :cached do
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
      keys = []
      keys << self.id
      keys << self.friendly_id if self.respond_to?(:friendly_id)
      keys << self.to_param
      keys.uniq.map{|id| self.class.dv8_key(id) }
    end

  end
end