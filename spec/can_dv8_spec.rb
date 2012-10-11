require 'spec_helper'


describe 'CanDv8 mixin' do

  class Joe
    include Dv8::CanDv8
  end

  let(:joe){ Joe.new }

  it 'should respond to things' do
    joe.should respond_to(:dv8ed?)
    joe.should respond_to(:dv8!)
  end

  it 'should set the dv8ed to true' do
    joe.should_not be_dv8ed
    joe.dv8!
    joe.should be_dv8ed
  end

  it 'should handle blocks properly' do
    joe.should_not be_dv8ed
    joe.dv8! do
      joe.should be_dv8ed
    end
    joe.should_not be_dv8ed
  end

  it 'should reset if an error is raised' do

    lambda{
      joe.dv8! do
        raise 'issue'
      end
    }.should raise_error

    joe.should_not be_dv8ed

  end

end