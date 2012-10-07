require 'spec_helper'

describe 'ActiveRecord Integration' do

  it 'should hook AR::Base with Dv8' do
    ActiveRecord::Base.should respond_to(:inherited_with_dv8)
    ActiveRecord::Base.should_not respond_to(:cached)
    ActiveRecord::Base.should_not respond_to(:cfind)
  end

  it 'should add scopes and cfinds to descendents' do
    User.should respond_to(:cached)
    User.should respond_to(:cfind)
  end

  it 'should provide dv8 keys to descendents' do
    User.instance_methods.should include('dv8_keys')
  end

end