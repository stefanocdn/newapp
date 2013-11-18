require 'spec_helper'

describe Membership do
  let(:user) { FactoryGirl.create(:user) }
  let(:group) { FactoryGirl.create(:group) }
  let(:membership) { user.memberships.build(group_id: group.id) }

  subject { membership }

  it { should be_valid }

  describe "accessible attributes" do
	it "should not allow access to user_id" do
		expect do
		Membership.new(user_id: user.id)
  		end.to raise_error(ActiveModel::MassAssignmentSecurity::Error)
	end
  end

  describe "user methods" do
	it { should respond_to(:user) }
	it { should respond_to(:group) }
	its(:user) { should == user }
	its(:group) { should == group }
  end

  describe "when group id is not present" do
	before { membership.group_id = nil }
	it { should_not be_valid }
  end

  describe "when user id is not present" do
	before { membership.user_id = nil }
	it { should_not be_valid }
  end
end
