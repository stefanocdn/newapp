class LessonsController < ApplicationController
	before_filter :signed_in_user,
                only: [:new, :create, :destroy]
    before_filter :correct_user, only: :destroy

	def index
	  @lessons = Lesson.all
	end

	def new
	  @lesson = current_user.lessons.build
	end

	def create
	  @lesson = current_user.lessons.build(params[:lesson])
	  if @lesson.save
	  	flash[:success] = "Lesson created"
	  	redirect_to current_user
	  else
	  	render 'new'
	  end
	end

	def destroy
	  @lesson.destroy
	  redirect_to current_user
	end

	private

	def correct_user
	  @lesson = current_user.lessons.find_by_id(params[:id])
	  redirect_to current_user if @lesson.nil?
	end
end