require 'spec_helper'

describe 'ActiveRecord Integration' do

  let(:user){ User.create(:first_name => 'Mikey', :last_name => 'Foreman') }
  let(:admin){ Admin.create(:first_name => 'John', :last_name => 'Juniper') }
  let(:chair){ Chair.create(:name => 'Viking') }

  it 'should add scopes and cfinds to descendents' do
    User.should respond_to(:cached)
    User.should respond_to(:cfind)
  end

  it 'should propagate to child classes' do
    Admin.should respond_to(:cached)
    Admin.should respond_to(:cfind)
  end

  it 'should provide dv8 keys to descendents' do
    User.instance_methods.map(&:to_s).should include('dv8_keys')
  end

  it 'should find a record and only hit the cache once' do
    user
    ActiveRecord::Base.connection.should_receive(:select_all).once.and_return([user.attributes])
    User.cfind(user.id)
    User.cfind(user.id)
  end

  it 'should find a record when queried through a parent class' do
    admin
    ActiveRecord::Base.connection.should_receive(:select_all).once.and_return([admin.attributes])
    Admin.cfind(admin.id)
    User.cfind(admin.id).should be_a(Admin)
  end

  it 'should actually retrieve the user and instantiate a new object' do
    a = User.cfind(user.id)
    b = User.cfind(user.id)
    a.should eql(user)
    b.should eql(user)

    a.object_id.should_not eql(b.object_id)
    b.object_id.should_not eql(user.object_id)
    a.object_id.should_not eql(user.object_id)
  end

  it 'should behave normally when dv8 is not included' do
    c = chair
    u = user
    u.chair = chair
    u.save

    c.should_not respond_to(:cached_user)
    c.user.should eql(user)
  end

  context 'with dv8 models' do

    class FakeModel
      def self.after_update(*args); end
      def self.after_touch(*args); end
      def self.scope(*args, &block); Module.new(&block); end
      def self.table_name; 'fake_model'; end
      def self.reflect_on_association(*args); nil; end

      def initialize(options = {})
        options.reverse_merge(:friendly_id => nil, :id => nil, :to_param => nil, :slug => nil).each do |k,v|
          class_eval <<-EO
            def #{k}; #{v.inspect}; end
          EO
        end
      end

      include Dv8::Base
    end

    it 'should build dv8_keys properly' do
      keys(:id => 44, :friendly_id => '44').should eql([
        'fake_model-44'
      ])

      keys(:id => 50, :friendly_id => 'faker').should eql([
        'fake_model-50',
        'fake_model-faker'
      ])

      keys(:id => 60, :friendly_id => 'something', :to_param => 'test').should eql([
        'fake_model-60',
        'fake_model-something',
        'fake_model-test'
      ])

      keys(:id => 70, :friendly_id => 'other', :to_param => 'other').should eql([
        'fake_model-70',
        'fake_model-other'
      ])

      keys(:id => 80, :slug => 'anything').should eql([
        'fake_model-80',
        'fake_model-anything'
      ])
    end

    it 'should expire all dv8 keys' do
      Rails.cache.should_receive(:delete).with('fake_model-12').once
      Rails.cache.should_receive(:delete).with('fake_model-test').once
      Rails.cache.should_receive(:delete).with('fake_model-crazy').once
      mod(:id => 12, :friendly_id => 'test', :to_param => 'crazy').expire_dv8
    end

    def keys(fields)
      FakeModel.new(fields).dv8_keys
    end

    def mod(fields)
      FakeModel.new(fields)
    end
  end
end
