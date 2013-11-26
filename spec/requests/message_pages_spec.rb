require 'spec_helper'

describe "Message Pages" do

  subject { page }

  let(:user) { FactoryGirl.create(:user) }
  let(:other_user) { FactoryGirl.create(:user) }

  before { sign_in user }

  describe "message creation" do

	before { visit user_path(other_user) }

	it { should have_selector 'button', text: 'Send Message' }
	it { should have_selector 'button', text: 'Send' }

	describe "with invalid information" do
	  it "should not create a message" do
	    expect { click_button "Send" }.not_to change(Message, :count)
	  end

	  describe "error messages" do
	    before { click_button "Send" }
	    it { should have_selector('div.alert.alert-danger', text: 'Missing subject/content or too long') }
	  end
  	end

	describe "with valid information" do

	  before do
	    fill_in 'message_subject', with: "Lorem ipsum"
	    fill_in 'message_body', with: "Lorem ipsum"
	  end

	  it "should create a message" do
		expect { click_button "Send" }.to change(Message, :count).by(2)
	  end
	end
  end
end
