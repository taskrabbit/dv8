module Dv8
  class Railtie < Rails::Railtie

    initializer "dv8.hook_activerecord" do |app|
      ActiveSupport.on_load(:active_record) do
        ActiveRecord::Base.send(:include, Dv8::Base)
        ActiveRecord::Associations::BelongsToAssociation.send(:include, Dv8::BelongsTo)
        ActiveRecord::Associations::BelongsToPolymorphicAssociation.send(:include, Dv8::BelongsToPolymorphic)
      end
    end

  end
end