module Dv8
  module AlwaysCache
    extend ActiveSupport::Concern

    included do
      class << self
        alias_method_chain :find, :dv8_cache
      end
    end


    module ClassMethods
      def find_with_dv8_cache(*args)
        self.cached.find_without_dv8_cache(*args)
      end
    end

  end
end