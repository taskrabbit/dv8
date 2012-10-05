module Dv8
  module SingularAssociation
    extend ActiveSupport::Concern

    included do
      alias_method_chain :target_scope, :cfind
    end

    def target_scope_with_cfind
      s = target_scope_without_cfind
      if owner.using_cfind
        s = s.cached
        s.instance_eval do
          def to_a
            pk_node = self.arel.constraints.first.children.first rescue nil
            return super unless pk_node
            return super unless pk_node.left.name == klass.primary_key
            find_some([pk_node.right])
          end
        end
      end
      s
    end

  end
end