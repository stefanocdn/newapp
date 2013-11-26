require 'spec_helper'

describe "Authentication" do

  subject { page }

  describe "signin page" do
    before { visit signin_path }

    it { should have_selector('h1',    text: 'Sign in') }
    it { should have_selector('title', text: 'Sign in') }
  end

  describe "signin" do
    before { visit signin_path }

    describe "with invalid information" do
      before { click_button "Sign in" }

      it { should have_selector('title', text: 'Sign in') }
      it { should have_selector('div.alert.alert-error', text: 'Invalid') }

      describe "after visiting another page" do
        before { click_link "Home" }
        it { should_not have_selector('div.alert.alert-error') }
      end
    end

    describe "with valid information" do
      let(:user) { FactoryGirl.create(:user) }
      before do
        fill_in "Email",    with: user.email.upcase
        fill_in "Password", with: user.password
        click_button "Sign in"
      end

      it { should have_selector('title', text: user.to_s) }

      it { should have_link('Users',    href: users_path) }
      it { should have_link('Profile',  href: user_path(user)) }
      it { should have_link('Settings', href: edit_user_path(user)) }
      it { should have_link('Sign out', href: signout_path) }
      it { should_not have_link('Sign in', href: signin_path) }

      describe "followed by signout" do
        before { click_link "Sign out" }
        it { should have_link('Sign in') }
      end
    end
  end

  describe "authorization" do

    describe "for non-signed-in users" do
      let(:user) { FactoryGirl.create(:user) }
      let(:group) { FactoryGirl.create(:group) }

      describe "when attempting to visit a protected page" do
        before do
          visit edit_user_path(user)
          fill_in "Email",    with: user.email
          fill_in "Password", with: user.password
          click_button "Sign in"
        end

        describe "after signing in" do

          it "should render the desired protected page" do
            page.should have_selector('title', text: 'Edit user')
          end

          describe "when signing in again" do
            before do
              delete signout_path
              visit signin_path
              fill_in "Email",    with: user.email
              fill_in "Password", with: user.password
              click_button "Sign in"
            end

            it "should render the default (profile) page" do
              page.should have_selector('title', text: user.to_s)
            end
          end
        end
      end

      describe "in the Groups controller" do
        describe "visiting the user page" do
          before { visit user_group_path(group) }
          it { should have_selector('title', text: 'Sign in') }
        end
      end

      describe "in the Users controller" do

        describe "visiting the edit page" do
          before { visit edit_user_path(user) }
          it { should have_selector('title', text: 'Sign in') }
        end

        describe "submitting to the update action" do
          before { put user_path(user) }
          specify { response.should redirect_to(signin_url) }
        end

        describe "visiting user index" do
          before { visit users_path }
          it { should have_selector('title', text: 'Sign in') }
        end

        describe "visiting the group page" do
          before { visit group_user_path(user) }
          it { should have_selector('title', text: 'Sign in') }
        end

        describe "visiting the reviewers page" do
          before { visit reviewers_user_path(user) }
          it { should have_selector('title', text: 'Sign in') }
        end

        describe "visiting the reviewed page" do
          before { visit reviewing_user_path(user) }
          it { should have_selector('title', text: 'Sign in') }
        end

        describe "visiting the inbox page" do
          before { visit inbox_user_path(user) }
          it { should have_selector('title', text: 'Sign in') }
        end

        describe "visiting the sent messages page" do
          before { visit outbox_user_path(user) }
          it { should have_selector('title', text: 'Sign in') }
        end

        # describe "visiting the followers page" do
        #   before { visit followers_user_path(user) }
        #   it { should have_selector('title', text: 'Sign in') }
        # end
      end

      describe "in the Reviews controller" do

        describe "submitting to the create action" do
          before { post reviews_path }
          specify { response.should redirect_to(signin_url) }
        end

        describe "submitting to the destroy action" do
          before { delete review_path(FactoryGirl.create(:review)) }
          specify { response.should redirect_to(signin_url) }
        end
      end


      describe "in the Lessons controller" do

        describe "submitting to the new action" do
          before { get new_lesson_path }
          specify { response.should redirect_to(signin_url) }
        end

        describe "submitting to the create action" do
          before { post lessons_path }
          specify { response.should redirect_to(signin_url) }
        end

        describe "submitting to the destroy action" do
          before { delete lesson_path(FactoryGirl.create(:lesson)) }
          specify { response.should redirect_to(signin_url) }
        end
      end

      # describe "in the Microposts controller" do

      #   describe "submitting to the create action" do
      #     before { post microposts_path }
      #     specify { response.should redirect_to(signin_url) }
      #   end

      #   describe "submitting to the destroy action" do
      #     before { delete micropost_path(FactoryGirl.create(:micropost)) }
      #     specify { response.should redirect_to(signin_url) }
      #   end
      # end

      describe "in the Messages controller" do

        describe "submitting to the create action" do
          before { post messages_path }
          specify { response.should redirect_to(signin_url) }
        end

        describe "submitting to the destroy action" do
          before { delete message_path(FactoryGirl.create(:message)) }
          specify { response.should redirect_to(signin_url) }
        end
      end

      describe "in the Membership controller" do
        describe "submitting to the create action" do
          before { post memberships_path }
          specify { response.should redirect_to(signin_url) }
        end

        describe "submitting to the destroy action" do
          before { delete membership_path(1) }
          specify { response.should redirect_to(signin_url) }
        end
      end

      describe "in the Scholarship controller" do
        describe "submitting to the create action" do
          before { post scholarships_path }
          specify { response.should redirect_to(signin_url) }
        end

        describe "submitting to the destroy action" do
          before { delete scholarship_path(1) }
          specify { response.should redirect_to(signin_url) }
        end
      end
    end

    describe "as wrong user" do
      let(:user) { FactoryGirl.create(:user) }
      let(:wrong_user) { FactoryGirl.create(:user, email: "wrong@example.com") }
      before { sign_in user }

      describe "visiting Users#edit page" do
        before { visit edit_user_path(wrong_user) }
        it { should have_selector('title', text: full_title('')) }
      end

      describe "visiting Users#inbox page" do
        before { visit inbox_user_path(wrong_user) }
        it { should have_selector('title', text: full_title('')) }
      end

      describe "visiting Users#inbox page" do
        before { visit inbox_user_path(wrong_user) }
        it { should have_selector('title', text: full_title('')) }
      end

      describe "submitting a PUT request to the Users#update action" do
        before { put user_path(wrong_user) }
        specify { response.should redirect_to(root_url) }
      end
    end

    describe "as non-admin user" do
      let(:user) { FactoryGirl.create(:user) }
      let(:non_admin) { FactoryGirl.create(:user) }

      before { sign_in non_admin }

      describe "submitting a DELETE request to the Users#destroy action" do
        before { delete user_path(user) }
        specify { response.should redirect_to(root_url) }
      end
    end
  end
end