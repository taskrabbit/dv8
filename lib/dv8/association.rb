module Dv8
  module Association
    extend ActiveSupport::Concern

    included do
      include ::Dv8::CanDv8
      alias_method_chain :scoped, :dv8
    end

    def scoped_with_dv8
      s = scoped_without_dv8
      if self.owner.dv8ed?
        s = s.cached
        if self.class < ActiveRecord::Associations::SingularAssociation
          s.instance_eval do
            def to_a
              pk_node = self.arel.constraints.first.children.first rescue nil
              return super unless pk_node
              return super unless pk_node.left.name == klass.primary_key
              find_some([pk_node.right])
            end
          end
        end
      end
      s
    end

  end
end