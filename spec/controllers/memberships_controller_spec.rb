require 'spec_helper'

describe MembershipsController do

  let(:user) { FactoryGirl.create(:user) }
  let(:group) { FactoryGirl.create(:group) }

  before { sign_in user }

  describe "creating a membership with Ajax" do

    it "should increment the Membership count" do
      expect do
        xhr :post, :create, membership: { group_id: group.id }
      end.to change(Membership, :count).by(1)
    end

    it "should respond with success" do
      xhr :post, :create, membership: { group_id: group.id }
      response.should be_success
    end
  end

  describe "destroying a membership with Ajax" do

    before { user.join!(group) }
    let(:membership) { user.memberships.find_by_group_id(group) }

    it "should decrement the membership count" do
      expect do
        xhr :delete, :destroy, id: membership.id
      end.to change(Membership, :count).by(-1)
    end

    it "should respond with success" do
      xhr :delete, :destroy, id: membership.id
      response.should be_success
    end
  end
end