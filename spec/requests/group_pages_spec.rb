require 'spec_helper'

describe "GroupPages" do

  subject { page }

  describe "profile page" do
    let(:group) { FactoryGirl.create(:group) }

    before { visit group_path(group) }

    it { should have_selector('h1',    text: group.name) }
    it { should have_selector('title', text: group.name) }

    describe "users count" do
    let(:user) { FactoryGirl.create(:user) }
      before do
        user.join!(group)
        visit group_path(group)
      end
      it { should have_link("1 users", href: user_group_path(group)) }
    end
  end

  describe "group users" do
    let(:user) { FactoryGirl.create(:user) }
    let(:group) { FactoryGirl.create(:group) }
    before { user.join!(group) }

    describe "users in the group" do
      before do
        sign_in user
        visit user_group_path(group)
      end

      it { should have_selector('title', text: full_title('Members')) }
      it { should have_selector('h3', text: 'Members') }
      it { should have_link(user.to_s, href: user_path(user)) }
    end
  end

  describe "join/leave buttons" do
  	  let(:user) { FactoryGirl.create(:user) }
      let(:group) { FactoryGirl.create(:group) }
      before { sign_in user }

      describe "joining a group" do
        before { visit group_path(group) }

        it "should increment the user count of the group" do
          expect do
            click_button "Join Group"
          end.to change(group.users, :count).by(1)
        end

        it "should increment the group count of the user" do
          expect do
            click_button "Join Group"
          end.to change(user.groups, :count).by(1)
        end

        describe "toggling the button" do
          before { click_button "Join Group" }
          it { should have_selector('input', value: 'Leave') }
        end
      end

      describe "leaving a group" do
        before do
          user.join!(group)
          visit group_path(group)
        end

        it "should decrement the group count of the user" do
          expect do
            click_button "Leave"
          end.to change(user.groups, :count).by(-1)
        end

        it "should decrement the user count of the group" do
          expect do
            click_button "Leave"
          end.to change(group.users, :count).by(-1)
        end

        describe "toggling the button" do
          before { click_button "Leave" }
          it { should have_selector('input', value: 'Join Group') }
        end
      end
    end
end
