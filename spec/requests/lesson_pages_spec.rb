require 'spec_helper'

describe "Lesson Pages" do
    
  subject { page }

  let(:user) { FactoryGirl.create(:user) }
  # let(:category) { FactoryGirl.create(:category) }

  before do
    sign_in user
    # category.save
  end

  describe "lesson creation" do
    before { visit new_lesson_path }

    describe "with invalid information" do

      it "should not create a lesson" do
        expect { click_button "Create my lesson" }.not_to change(Lesson, :count)
      end

      describe "error messages" do
        before { click_button "Create my lesson" }
        it { should have_content('error') }
      end
    end
    
    describe "with valid information" do

      before do
        fill_in "Title",         with: "Example"
        fill_in "Content",         with: "Lorem ipsum"
        # fill_in "Categories",  with: "Math"
        fill_in "Price",        with: 50
      end

      it "should create a lesson" do
        expect { click_button "Create my lesson" }.to change(Lesson, :count).by(1)
      end
    end
  end

  describe "lesson destruction" do
    before { FactoryGirl.create(:lesson, user: user) }

    describe "as correct user" do
      before { visit user_path(user) }

      it "should delete a lesson" do
        expect { click_link "delete" }.to change(Lesson, :count).by(-1)
      end
    end
  end
end
