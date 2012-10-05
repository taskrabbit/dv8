class User < ActiveRecord::Base
  attr_accessible :first_name, :last_name, :parent_id

  belongs_to :parent, :class_name => 'User'
  belongs_to :owner, :polymorphic => true
end
