class CategoriesController < ApplicationController

  def index
    @categories = Category.order(:name)
    respond_to do |format|
      format.html
      format.json { render json: @categories.tokens(params[:q]) }
    end
  end

  def show
    @category = Category.find(params[:id])
  end

  def new
    @category = category.new
  end

  def create
    @category = category.new(params[:category])
    if @category.save
      redirect_to @category, notice: "Successfully created category."
    else
      render :new
    end
  end

  def edit
    @category = category.find(params[:id])
  end

  def update
    @category = category.find(params[:id])
    if @category.update_attributes(params[:category])
      redirect_to @category, notice: "Successfully updated category."
    else
      render :edit
    end
  end

  def destroy
    @category = category.find(params[:id])
    @category.destroy
    redirect_to categorys_url, notice: "Successfully destroyed category."
  end

end