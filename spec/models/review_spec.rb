require 'spec_helper'

describe Review do
  let(:reviewer) { FactoryGirl.create(:user) }
  let(:reviewed) { FactoryGirl.create(:user) }
  let(:review) { reviewer.reviews.build(content: "Lorem ipsum", reviewed_id: reviewed.id) }

	subject { review }

	it { should respond_to(:reviewer) }
	it { should respond_to(:reviewer_id) }
	it { should respond_to(:reviewed) }
	it { should respond_to(:reviewed_id) }
	it { should respond_to(:content) }
	it { should be_valid }

	describe "accessible attributes" do
	  it "should not allow access to reviewer_id" do
		expect do
		Review.new(reviewer_id: reviewer.id)
	  	end.to raise_error(ActiveModel::MassAssignmentSecurity::Error)
	  end
  	end

  	describe "reviewer methods" do
	  it { should respond_to(:reviewer) }
	  it { should respond_to(:reviewed) }
	  its(:reviewer) { should == reviewer }
	  its(:reviewed) { should == reviewed }
	end

	describe "when reviewed id is not present" do	
	  before { review.reviewed_id = nil }
	  it { should_not be_valid }
	end
	  
	describe "when reviewer id is not present" do
	  before { review.reviewer_id = nil }
	  it { should_not be_valid }
	end

	describe "with blank content" do
	  before { review.content = " " }
	  it { should_not be_valid }
	end
end
