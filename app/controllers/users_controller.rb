class UsersController < ApplicationController
  before_filter :signed_in_user,
                only: [:index, :edit, :update, :destroy, :group, :reviewing, :reviewers, :inbox, :outbox]
  before_filter :correct_user,   only: [:edit, :update, :inbox, :outbox]
  before_filter :admin_user,     only: :destroy

  def index
    @users = User.text_search(params[:query]).paginate(page: params[:page])
  end

  def show
    @user = User.find(params[:id])
    @scholarships = @user.scholarships
    @lessons = @user.lessons
    @reverse_reviews = @user.reverse_reviews.paginate(page: params[:page])
    @reviews = @user.reviews.paginate(page: params[:page])
    # @microposts = @user.microposts.paginate(page: params[:page])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      sign_in @user
      flash[:success] = "Welcome to the Sample App!"
      redirect_to @user
    else
      render 'new'
    end
  end

  def edit
    current_user.scholarships.build
  end

  def update
    if @user.update_attributes(params[:user])
      flash[:success] = "Profile updated"
      sign_in @user
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User destroyed."
    redirect_to users_url
  end

  def group
    @title = "Your Groups"
    @user = User.find(params[:id])
    @groups = @user.groups.paginate(page: params[:page])
    render 'show_groups'
  end

  def reviewing
          @title = "Reviewing"
          @user = User.find(params[:id])
          @users = @user.reviewed_users.paginate(page: params[:page])
          render 'show_review'
  end

  def reviewers
          @title = "Reviewers"
          @user = User.find(params[:id])
          @users = @user.reviewers.paginate(page: params[:page])
          render 'show_review'
  end

  def inbox
    @title = "Inbox"
    @user = User.find(params[:id])
    @messages = @user.messages.received(page: params[:page])
    @last_sub = @user.messages ? @user.messages.first.subject : nil
    @last_conv = Message.conversation(@last_sub).sent
    render 'show_inbox'
  end

  def outbox
    @title = "Sent Messages"
    @user = User.find(params[:id])
    @messages = @user.messages.sent.paginate(page: params[:page])
    render 'show_sent'
  end

  private

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end

    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end
end