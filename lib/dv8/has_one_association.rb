module Dv8
  module HasOneAssociation
    extend ActiveSupport::Concern

    included do
      alias_method_chain :find_target, :dv8
    end

    private

    def find_target_with_dv8
      return find_target_without_dv8 unless self.owner.respond_to?(:dv8ed?) && self.owner.dv8ed?

      id = scoped.select(reflection.klass.primary_key).first
      object = id ? reflection.klass.cfind(id) : nil
      set_inverse_instance(object)
      object
    end
  end
end