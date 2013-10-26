class GroupsController < ApplicationController

  before_filter :signed_in_user, only: [:user]

  def new
  end

  def show
  	@group = Group.find(params[:id])
  end

  def user
  	@title = "Members"
    @group = Group.find(params[:id])
    @users = @group.users.paginate(page: params[:page])
    render 'show_users'
  end
end
