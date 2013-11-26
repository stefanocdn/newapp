require 'spec_helper'

describe Message do

  let(:user) { FactoryGirl.create(:user) }
  before do
    @message = user.messages.build(subject: "Lorem ipsum",
    	body: "Lorem ipsum")
  end

  subject { @message }

  it { should respond_to(:subject) }
  it { should respond_to(:body) }
  it { should respond_to(:sent) }
  it { should respond_to(:user_id) }
  it { should respond_to(:user) }
  its(:user) { should == user }

  it { should be_valid }

  # describe "accessible attributes" do
  #   it "should not allow access to user_id" do
  #     expect do
  #       message.new(user_id: user.id)
  #     end.to raise_error(ActiveModel::MassAssignmentSecurity::Error)
  #   end
  # end

  describe "when user_id is not present" do
    before { @message.user_id = nil }
    it { should_not be_valid }
  end

  describe "with blank body" do
    before { @message.body = " " }
    it { should_not be_valid }
  end

  describe "with blank subject" do
    before { @message.subject = " " }
    it { should_not be_valid }
  end

  describe "with subject that is too long" do
    before { @message.subject = "a" * 141 }
    it { should_not be_valid }
  end
end
