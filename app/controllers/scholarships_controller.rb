class ScholarshipsController < ApplicationController
	before_filter :signed_in_user
	before_filter :correct_user, only: :destroy

	def create
	  @scholarship = current_user.scholarships.build(params[:scholarship])
		if @scholarship.save
		  flash[:success] = "Education created!"
		  redirect_to edit_user_path(current_user)
		else
		  redirect_to current_user, alert: "Wrong submission"
		end
	end

	def destroy
		@scholarship.destroy
		flash[:notice] = "Scholarship destroyed"
		redirect_to current_user
	end

	private

	def correct_user
	  @scholarship = current_user.scholarships.find_by_id(params[:id])
	  redirect_to current_user if @scholarship.nil?
	end
end