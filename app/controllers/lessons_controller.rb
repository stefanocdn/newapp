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

	def show
	  @lesson = Lesson.find(params[:id])
	end

	def create
	  @lesson = current_user.lessons.build(params[:lesson])
	  if @lesson.save
	  	flash[:success] = "Lesson created"
	  	redirect_to @lesson, notice: "Successfully created lesson!"
	  else
	  	render 'new'
	  end
	end

	def destroy
	  @lesson.destroy
	  redirect_to current_user
	end

	def edit
      @lesson = Lesson.find(params[:id])
    end

    def update
      @lesson = Lesson.find(params[:id])
      if @lesson.update_attributes(params[:lesson])
        redirect_to @lesson, notice: "Successfully updated lesson."
      else
        render :edit
      end
    end

	private

	def correct_user
	  @lesson = current_user.lessons.find_by_id(params[:id])
	  redirect_to current_user if @lesson.nil?
	end
end