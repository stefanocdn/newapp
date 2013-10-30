class ReviewsController < ApplicationController
before_filter :signed_in_user, only: [:create, :destroy]
before_filter :correct_user,   only: :destroy

  def index
  	@reviews = Review.paginate(page: params[:page])
  end

  def create
    @user = User.find(params[:review][:reviewed_id])
    @review = current_user.reviews.build(params[:review])
    if @review.save
      respond_to do |format|
        format.html { redirect_to @user, success: "Review created" }
        format.js
      end
    else
      flash[:error] = "Content of the review can't be blank."
      redirect_to @user
      # render partial: "users/show", member: @user
    end
  end

  def destroy
    @review.destroy
    redirect_to current_user
  end

  private

    def correct_user
      @review = current_user.reviews.find_by_id(params[:id])
      redirect_to root_url if @review.nil?
    end
end
