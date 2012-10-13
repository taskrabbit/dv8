require 'spec_helper'

describe 'Has Many Through Associations' do

  let(:user){ u = User.create(:first_name => 'Jim', :last_name => 'Phillips'); u.children << child; u }
  let(:child){ User.create(:first_name => 'Child', :last_name => 'Person', :best_friend => friend) }
  let(:friend){ User.create(:first_name => 'Parent', :last_name => 'Person') }


  it 'should allow hmt to be accessed via a cached_ method' do
    User.new.should respond_to(:cached_secondary_friends)
  end

  it 'should not hit the cache when the relationship isnt accessed through cached_' do
    User.should_receive(:cached).never
    User.new.secondary_friends
  end

  it 'should hit the cache when accessed via cached_' do
    original = User.method(:cached)
    User.should_receive(:cached).once do 
      original.call
    end
    user.cached_secondary_friends
  end

  it 'should only hit the db once' do
    sec = user.cached_secondary_friends.first
    key = sec.dv8_keys.first
    Rails.cache.read(key).should_not be_blank
    Rails.cache.should_receive(:read).with(key).once.and_return(sec.attributes)
    user.reload.cached_secondary_friends.first.should eql(sec)
  end
end