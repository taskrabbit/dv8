module Dv8
  module BelongsTo
    extend ActiveSupport::Concern
    
    included do
      alias_method_chain :find_target, :cfind
    end

    private

    def find_target_with_cfind
      old_reflection = @reflection
      return find_target_without_cfind unless @owner.using_cfind
      @reflection = @reflection.dup
      @reflection.instance_eval do
        def klass
          super.cached
        end
      end  
      find_target_without_cfind
    ensure
      @reflection = old_reflection
    end
  end
end