class StaticPagesController < ApplicationController
  def home
  	@reviews = Review.all
  	@lessons = Lesson.all
  end

  def help
  end

  def contact
  end

  def about
  end
  
end
