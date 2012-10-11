require 'spec_helper'

describe 'Has One Relationships' do

  let(:user){
    u = User.create(:first_name => 'Mike', :last_name => 'Middlesworth')
    u.update_attribute(:parent_id, u.id)
    u.reload
  }

  it 'should allow belongs_to relationships to be accessible via the cache' do
    User.new.should respond_to(:cached_child)
  end

  it 'should not hit the cache when the belongs_to is used normally' do
    user.should_receive(:dv8!).never
    user.child.should eql(user)
  end

  it 'should check the cache when a belongs_to is hit with the cache' do
    original = user.method(:dv8!)
    user.should_receive(:dv8!).once do |&block|
      original.call(&block)
    end
    user.cached_child.should eql(user)
  end

end