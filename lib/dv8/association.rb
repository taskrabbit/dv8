module Dv8
  module Association
    extend ActiveSupport::Concern

    included do
      alias_method_chain :scoped, :dv8
    end

    def scoped_with_dv8
      s = scoped_without_dv8
      if self.owner.dv8ed?
        s = s.cached
        s.extend SingularAssociationRetriever 
      end
      s
    end

    private

    module SingularAssociationRetriever

      def to_a
        return super unless dv8_id_node

        result = find_some([dv8_id_node.right])[0]

        return [] unless result

        return [result] unless dv8_type_class

        result.is_a?(dv8_type_class) ? [result] : []
      end

      private

      def dv8_constraint_nodes
        @dv8_constraint_nodes ||= self.arel.constraints.first.children rescue []
      end

      def dv8_id_node
        @dv8_id_node ||= dv8_constraint_nodes.detect{|n| n.left.name == klass.primary_key }
      end

      def dv8_type_class
        typ_node = dv8_constraint_nodes.reject{|n| n == dv8_id_node }.first
        return nil unless typ_node
        typ_node.right.to_s.constantize
      end
    end

  end
end