require 'spec_helper'

describe "Scholarship pages" do

  subject { page }

  let(:user) { FactoryGirl.create(:user) }
  before { sign_in user }

  describe "scholarship creation" do
	before { visit user_path(user) }
	before { click_link "Edit Profile" }

	describe "with invalid information" do
	  it "should not create a scholarship" do
		expect { click_button "Add Education" }.not_to change(Scholarship, :count)
	  end

	  describe "error messages" do
		before { click_button "Add Education" }

		it { should have_selector('div.alert.alert-alert', text: 'Wrong submission') }
	  end
	end

	describe "with valid information" do
	  before do
	  	fill_in 'scholarship_degree', with: "Masters"
	  	fill_in 'scholarship_field', with: "Math"
	  	fill_in 'scholarship_school_name', with: "Ecole Polytechnique"
	  end

	  it "should create a scholarship" do
		expect { click_button "Add Education" }.to change(Scholarship, :count).by(1)
	  end
	end
  end
end