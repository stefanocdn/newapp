class StaticPagesController < ApplicationController
  def home
  	@reviews = Review.all[0..2]
  	@lessons = Lesson.all
  end

  def help
  end

  def contact
  end

  def about
  end
  
end
