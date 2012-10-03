module Dv8
  module BelongsToPolymorphic
    extend ActiveSupport::Concern

    included do
      alias_method_chain :association_class, :cfind
    end

    private

    def association_class_with_cfind
      result = association_class_without_cfind
      result = result.try(:cached) if @owner.using_cfind
      result
    end

  end
end