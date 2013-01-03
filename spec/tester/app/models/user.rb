class User < ActiveRecord::Base
  attr_accessible :first_name, :last_name, :parent_id, :best_friend

  belongs_to :parent, :class_name => 'User'
  belongs_to :owner, :polymorphic => true, :class_name => 'User'
  belongs_to :best_friend, :class_name => 'User'

  has_many :children, :foreign_key => :parent_id, :class_name => 'User'
  has_many :secondary_friends, :through => :children, :source => :best_friend

  has_and_belongs_to_many :friends, :join_table => 'users_friends', :class_name => 'User', :foreign_key => :user_id, :association_foreign_key => :friend_id

  has_one :child, :foreign_key => :parent_id, :class_name => 'User'
end
