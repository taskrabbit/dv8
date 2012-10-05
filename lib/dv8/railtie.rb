module Dv8
  class Railtie < Rails::Railtie

    initializer "dv8.hook_activerecord" do |app|
      ActiveSupport.on_load(:active_record) do
        Dv8.hook!
      end
    end

  end
end