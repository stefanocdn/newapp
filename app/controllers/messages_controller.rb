class MessagesController < ApplicationController
	before_filter :signed_in_user
	before_filter :correct_user, only: :destroy

	def create
	  @user = User.find(params[:message][:recipient_id])
	  @message = current_user.messages.build(params[:message])
		if @message.save
		  @message.send_message(current_user, @user)
		  flash[:success] = "Message sent!"
		  redirect_to @user
		else
		  flash[:danger] = "Missing subject/content or too long"
		  redirect_to @user
		end
	end

	def destroy
		@message.destroy
		flash[:notice] = "Message destroyed"
		redirect_to current_user
	end

	def index
	  @subject = params[:subject]
	  @chat_messages = Message.conversation(@subject).sent.to_a
	  respond_to do |format|
		format.html { redirect_to @chat_messages }
		format.js
	  end
	end

	private

	def correct_user
	  @message = current_user.messages.find_by_id(params[:id])
	  redirect_to current_user if @message.nil?
	end
end