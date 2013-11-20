require 'spec_helper'

describe "Review Pages" do
  
  subject { page }

	let(:user) { FactoryGirl.create(:user) }
	let(:other_user) { FactoryGirl.create(:user) }
	
	before { sign_in user }
	
	describe "review creation" do
	
	  before { visit user_path(other_user) }
	
	  describe "with invalid information" do
		it "should not create a micropost" do
		expect { click_button "Post Review" }.not_to change(Review, :count)
	  end
	
	  describe "error messages" do
		before { click_button "Post Review" }

		it { should have_content('Content') }
		it { should have_selector('div.alert.alert-error', text: 'blank') }
	  end
	end

	describe "with valid information" do

	  before do
	    fill_in 'review_content', with: "Lorem ipsum"
	    choose('Rating 4')
	  end


	  it "should create a review" do
		expect { click_button "Post Review" }.to change(Review, :count).by(1)
	  end

	  it "should increment the reviewers count" do
	  	expect { click_button "Post Review" }.to change(other_user.reviewers, :count).by(1)
	  end

	  it "should increment the reviewed users count" do
	  	expect { click_button "Post Review" }.to change(user.reviewed_users, :count).by(1)
	  end

	end

	describe "reviewer count" do
        before do
          visit user_path(other_user)
          choose('Rating 4')
          fill_in 'review_content', with: "Lorem ipsum"
          click_button "Post Review"
          visit user_path(other_user)
        end

        it { should have_link("0 reviewing", href: reviewing_user_path(other_user)) }
        it { should have_link("1 reviewers", href: reviewers_user_path(other_user)) }
    end

    describe "reviewing count" do
        before do
          visit user_path(other_user)
          choose('Rating 4')
          fill_in 'review_content', with: "Lorem ipsum"
          click_button "Post Review"
          visit user_path(user)
        end

        it { should have_link("1 reviewing", href: reviewing_user_path(user)) }
        it { should have_link("0 reviewers", href: reviewers_user_path(user)) }
    end

    describe "review destruction" do
    	before do
    	 FactoryGirl.create(:review, reviewer: user, reviewed: other_user)
    	 visit user_path(user)
    	end

    	it "should delete review" do
    		expect { click_link "delete" }.to change(Review, :count).by(-1)
    	end
    end
end
end
