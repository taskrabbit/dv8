module Dv8
  module DescendantDecorator
    extend ActiveSupport::Concern
    
    included do
      after_update  :expire_cfind
      after_touch   :expire_cfind

      scope :cached do
        include ::Dv8::ScopeMethods
      end

    end


    module ClassMethods
      def cfind(*args)
        self.cached.find(*args)
      end


      def cfind_key(id)
        "#{self.table_name}-#{id}"
      end
    end


    def expire_cfind
      cfind_keys.each do |key|
        Rails.cache.delete(key)
      end
    end
    
    def cfind_keys
      keys = []
      keys << self.id
      keys << self.friendly_id if self.respond_to?(:friendly_id)
      keys << self.to_param
      keys.uniq.map{|id| self.class.cfind_key(id) }
    end

  end
end