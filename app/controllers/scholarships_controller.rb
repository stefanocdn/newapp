class ScholarshipsController < ApplicationController
	before_filter :signed_in_user

	def create
	  @scholarship = current_user.scholarships.build(params[:scholarship])
		if @scholarship.save
		  flash[:success] = "Education created!"
		  redirect_to current_user
		else
		  redirect_to current_user, alert: "Wrong submission"
		end
	end

	def destroy
	end
end