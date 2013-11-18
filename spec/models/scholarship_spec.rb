require 'spec_helper'

describe Scholarship do
  let(:user) { FactoryGirl.create(:user) }
  let(:school) { FactoryGirl.create(:school) }
  let(:scholarship) { user.scholarships.build(degree: "Master",
       field: "Maths", school_id: school.id) }

  subject { scholarship }

  it { should be_valid }

  describe "accessible attributes" do
	it "should not allow access to user_id" do
		expect do
		Scholarship.new(user_id: user.id)
  		end.to raise_error(ActiveModel::MassAssignmentSecurity::Error)
	end
  end

  describe "user methods" do
	  it { should respond_to(:user) }
	  it { should respond_to(:school) }
	  its(:user) { should == user }
	  its(:school) { should == school }
  end

  describe "when school id is not present" do
	  before { scholarship.school_id = nil }
	  it { should_not be_valid }
  end

  describe "when user id is not present" do
	  before { scholarship.user_id = nil }
	  it { should_not be_valid }
  end

  describe "with blank degree" do
    before { scholarship.degree = " " }
    it { should_not be_valid }
  end

  describe "with blank field" do
    before { scholarship.field = " " }
    it { should_not be_valid }
  end
end
