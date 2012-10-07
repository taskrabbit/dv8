require 'spec_helper'

describe 'Has many associations' do
  
  let(:user){
    u = User.create(:first_name => 'Mike', :last_name => 'Middlesworth')
    [child1, child2].each{|us| us.update_attribute(:parent_id, u.id) }
    u
  }

  let(:child1){ User.create(:first_name => 'John', :last_name => 'Smith') }
  let(:child2){ User.create(:first_name => 'Phil', :last_name => 'Collins') }

  it 'should not touch the cache unless told to' do
    User.should_receive(:cached).never
    user.children.all
  end

  it 'should attempt to use the cache if told to' do
    original = User.method(:cached)
    User.should_receive(:cached).once do 
      original.call
    end
    user.cached_children.all
  end

end