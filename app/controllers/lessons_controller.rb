class LessonsController < ApplicationController
	helper_method :sort_column, :sort_direction
	before_filter :signed_in_user,
                only: [:new, :create, :destroy]
    before_filter :correct_user, only: :destroy

	def index
	  if params[:tag]
    	@lessons = Lesson.tagged_with(params[:tag]).order(sort_column + ' ' + sort_direction).page(params[:page]).per_page(2)
      else
	    @lessons = Lesson.text_search(params[:search]).order(sort_column + ' ' + sort_direction).page(params[:page]).per_page(2)
	  end
	  @hash = Gmaps4rails.build_markers(@lessons) do |lesson, marker|
		marker.lat lesson.latitude
		marker.lng lesson.longitude
		marker.infowindow lesson.title
	  end
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

	def sort_column
      Lesson.column_names.include?(params[:sort]) ? params[:sort] : "title"
    end
  
    def sort_direction
      %w[asc desc].include?(params[:direction]) ?  params[:direction] : "asc"
    end
end