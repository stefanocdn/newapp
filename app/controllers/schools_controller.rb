class SchoolsController < ApplicationController

def index
  @schools = School.order(:name).where("name ilike ?", "%#{params[:term]}%")
  render json: @schools.map(&:name)
end

end