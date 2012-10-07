require 'spec_helper'

describe 'Has and Belongs to Many Association' do

  let(:user){ u = User.create(:first_name => 'User', :last_name => 'Popular'); u.friends << friend; u }
  let(:friend){ User.create(:first_name => 'Friendly', :last_name => 'Fred') }

  it 'should only hit the db once' do
    frend = user.reload.cached_friends.all.first
    key = frend.dv8_keys.first
    Rails.cache.read(key).should_not be_blank
    Rails.cache.should_receive(:read).with(key).once.and_return(frend.attributes)
    user.reload.cached_friends.all.first.should eql(frend)
  end

end