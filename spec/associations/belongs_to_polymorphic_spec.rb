require 'spec_helper'

describe "Polymorphic Belongs To Associations" do

  let(:user){
    u = User.create(:first_name => 'Doug', :last_name => 'Nut')
    u.owner = u
    u.save
    u
  }

  it 'should provide a cached_ method to access polymorphic associations' do
    User.new.should respond_to(:cached_owner)
  end

  it 'should access the normal relationship when attempted' do
    user.should_receive(:dv8!).never
    user.owner.should eql(user)
  end

  it 'should use the cache when access via the cached_ form' do
    user.should_receive(:dv8!).never
    user.cached_owner.should eql(user)
  end

  it 'should hit the cache before attempting to hit the db' do
    original = User.method(:cached)
    User.should_receive(:cached).once do 
      original.call
    end
    user.reload.cached_owner
  end

  it 'should only hit the db once if a record is pushed into the cache' do
    key = user.dv8_keys.first
    user.reload.cached_owner
    Rails.cache.read(key).should_not be_blank
    user.reload.cached_owner
  end

end