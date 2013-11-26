require 'spec_helper'

describe "User pages" do

  subject { page }

  describe "index" do

    before do
      sign_in FactoryGirl.create(:user)
      FactoryGirl.create(:user, first_name: "Bob", last_name: "Sponge", email: "bob@example.com")
      FactoryGirl.create(:user, first_name: "Ben", last_name: "Sings", email: "ben@example.com")
      visit users_path
    end

    it { should have_selector('title', text: 'All users') }

    describe "pagination" do

      before(:all) { 30.times { FactoryGirl.create(:user) } }
      after(:all)  { User.delete_all }

      let(:first_page)  { User.paginate(page: 1) }
      let(:second_page) { User.paginate(page: 2) }

      it { should have_link('Next') }
      its(:html) { should match('>2</a>') }

      it "should list each user" do
        User.all[0..2].each do |user|
          page.should have_selector('li', text: user.to_s)
        end
      end

      it "should list the first page of users" do
        first_page.each do |user|
          page.should have_selector('li', text: user.to_s)
        end
      end

      it "should not list the second page of users" do
        second_page.each do |user|
          page.should_not have_selector('li', text: user.to_s)
        end
      end

      describe "showing the second page" do
        before { visit users_path(page: 2) }

        it "should list the second page of users" do
          second_page.each do |user|
            page.should have_selector('li', text: user.to_s)
          end
        end
      end
    end

    describe "delete links" do

      it { should_not have_link('delete') }

      describe "as an admin user" do
        let(:admin) { FactoryGirl.create(:admin) }
        before do
          sign_in admin
          visit users_path
        end

        it { should have_link('delete', href: user_path(User.first)) }
        it "should be able to delete another user" do
          expect { click_link('delete') }.to change(User, :count).by(-1)
        end
        it { should_not have_link('delete', href: user_path(admin)) }
      end
    end
  end

  describe "profile page" do
    let(:user) { FactoryGirl.create(:user) }
    let!(:l1) { FactoryGirl.create(:lesson, user: user) }
    let!(:l2) { FactoryGirl.create(:lesson, user: user) }

    let(:user2) { FactoryGirl.create(:user) }
    let!(:r1) { FactoryGirl.create(:review, reviewer: user,
        reviewed: user2) }
    let!(:r2) { FactoryGirl.create(:review, reviewer: user,
        reviewed: user2) }
    let!(:r3) { FactoryGirl.create(:review, reviewer: user2,
        reviewed: user) }
    let!(:r4) { FactoryGirl.create(:review, reviewer: user2,
        reviewed: user) }

    before { visit user_path(user) }

    it { should have_selector('h3',    text: user.to_s) }
    it { should have_selector('title', text: user.to_s) }

    describe "group count" do
    let(:group) { FactoryGirl.create(:group) }
      before do
        user.join!(group)
        visit user_path(user)
      end
      it { should have_link("1 groups", href: group_user_path(user)) }
    end

    describe "lessons" do
      it { should have_content(l1.title) }
      it { should have_content(l1.content) }
      it { should have_content(l1.price) }
      it { should have_content(l2.title) }
      it { should have_content(l2.content) }
      it { should have_content(l2.price) }
      it { should have_content(user.lessons.count) }
    end

    describe "reviews made" do
      it { should have_content(r1.content) }
      it { should have_content(r2.content) }
      it { should have_content(user.reviews.count) }
    end

    describe "reverse reviews" do
      it { should have_content(r3.content) }
      it { should have_content(r4.content) }
      it { should have_content(user.reverse_reviews.count) }
    end

    # describe "follow/unfollow buttons" do
    #   let(:other_user) { FactoryGirl.create(:user) }
    #   before { sign_in user }

    #   describe "following a user" do
    #     before { visit user_path(other_user) }

    #     it "should increment the followed user count" do
    #       expect do
    #         click_button "Follow"
    #       end.to change(user.followed_users, :count).by(1)
    #     end

    #     it "should increment the other user's followers count" do
    #       expect do
    #         click_button "Follow"
    #       end.to change(other_user.followers, :count).by(1)
    #     end

    #     describe "toggling the button" do
    #       before { click_button "Follow" }
    #       it { should have_selector('input', value: 'Unfollow') }
    #     end
    #   end

    #   describe "unfollowing a user" do
    #     before do
    #       user.follow!(other_user)
    #       visit user_path(other_user)
    #     end

    #     it "should decrement the followed user count" do
    #       expect do
    #         click_button "Unfollow"
    #       end.to change(user.followed_users, :count).by(-1)
    #     end

    #     it "should decrement the other user's followers count" do
    #       expect do
    #         click_button "Unfollow"
    #       end.to change(other_user.followers, :count).by(-1)
    #     end

    #     describe "toggling the button" do
    #       before { click_button "Unfollow" }
    #       it { should have_selector('input', value: 'Follow') }
    #     end
    #   end
    # end
  end

  describe "profile page, education and professional" do
    let(:user) { FactoryGirl.create(:user) }
    let!(:s1) { FactoryGirl.create(:scholarship, user: user, degree: "Bachelor", field: "Eco", school_name: "HEC") }
    let!(:s2) { FactoryGirl.create(:scholarship, user: user, degree: "Masters", field: "Math", school_name: "X") }

    before { visit user_path(user) }
    before { click_link "Profile" }

    it { should have_selector('h4', text: "Education") }
    it { should have_selector('h4', text: "Positions") }

    describe "scholarships" do
      it { should have_content(s1.degree) }
      it { should have_content(s2.degree) }
      it { should have_content(s1.field) }
      it { should have_content(s2.field) }
      it { should have_content(s1.school.name) }
      it { should have_content(s2.school.name) }
    end
  end

  describe "signup page" do
    before { visit signup_path }

    it { should have_selector('h1',    text: 'Sign up') }
    it { should have_selector('title', text: full_title('Sign up')) }
  end

  describe "signup" do

    before { visit signup_path }

    let(:submit) { "Create my account" }

    describe "with invalid information" do
      it "should not create a user" do
        expect { click_button submit }.not_to change(User, :count)
      end

      describe "error messages" do
        before { click_button submit }

        it { should have_selector('title', text: 'Sign up') }
        it { should have_content('error') }
      end
    end

    describe "with valid information" do
      before do
        fill_in "First Name",         with: "Example"
        fill_in "Last Name",         with: "Name"
        fill_in "Email",        with: "user@example.com"
        fill_in "Password",     with: "foobar"
        fill_in "Confirmation", with: "foobar"
      end

      it "should create a user" do
        expect { click_button submit }.to change(User, :count).by(1)
      end

      describe "after saving the user" do
        before { click_button submit }

        let(:user) { User.find_by_email('user@example.com') }

        it { should have_selector('title', text: user.to_s) }
        it { should have_selector('div.alert.alert-success', text: 'Welcome') }
        it { should have_link('Sign out') }
      end
    end
  end

  describe "edit" do
    let(:user) { FactoryGirl.create(:user) }
    before do
      sign_in user
      visit edit_user_path(user)
    end

    describe "page" do
      it { should have_selector('h1',    text: "Update your profile") }
      it { should have_selector('title', text: "Edit user") }
      # it { should have_link('change', href: 'http://gravatar.com/emails') }
    end

    describe "with invalid information" do
      before { click_button "Save changes" }

      it { should have_content('error') }
    end

    describe "with valid information" do
      let(:new_fname)  { "NewFName" }
      let(:new_lname)  { "NewLName" }
      let(:new_email) { "new@example.com" }
      before do
        fill_in "First Name",             with: new_fname
        fill_in "Last Name",             with: new_lname
        fill_in "Email",            with: new_email
        fill_in "Password",         with: user.password
        fill_in "Confirm Password", with: user.password
        click_button "Save changes"
      end

      # it { should have_selector('title', text: new_name) }
      it { should have_selector('div.alert.alert-success') }
      it { should have_link('Sign out', href: signout_path) }
      specify { user.reload.first_name.should  == new_fname }
      specify { user.reload.last_name.should  == new_lname }
      specify { user.reload.email.should == new_email }
    end
  end

  describe "your groups" do
    let(:user) { FactoryGirl.create(:user) }
    let(:group) { FactoryGirl.create(:group) }
    before { user.join!(group) }

    describe "membership groups" do
      before do
        sign_in user
        visit group_user_path(user)
      end

      it { should have_selector('title', text: full_title('Your Groups')) }
      it { should have_selector('h3', text: 'Your Groups') }
      it { should have_link(group.name, href: group_path(group)) }
    end

  #   describe "followers" do
  #     before do
  #       sign_in other_user
  #       visit followers_user_path(other_user)
  #     end

  #     it { should have_selector('title', text: full_title('Followers')) }
  #     it { should have_selector('h3', text: 'Followers') }
  #     it { should have_link(user.name, href: user_path(user)) }
  #   end
  end

  describe "inbox/sent_messages" do
    let(:user) { FactoryGirl.create(:user) }
    let(:other_user) { FactoryGirl.create(:user) }
    let(:message) { FactoryGirl.create(:message, user: user) }
    before { message.send_message(user, other_user) }

    describe "Sent Messages" do
      before do
        sign_in user
        visit outbox_user_path(user)
      end

      it { should have_selector('title', text: full_title('Sent Messages')) }
      it { should have_selector('h3', text: 'Sent Messages') }
      it { should have_link(message.user.to_s, href: user_path(user)) }
    end

    describe "Inbox" do
      before do
        sign_in user
        visit inbox_user_path(user)
      end

      it { should have_selector('title', text: full_title('Inbox')) }
      it { should have_selector('h3', text: 'Inbox') }
      # it { should have_link(message.user.to_s, href: user_path(user)) }
    end
  end
end