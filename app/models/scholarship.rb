class Scholarship < ActiveRecord::Base
  attr_accessible :degree, :end_date, :field, :start_date, :school_name, :school_id

  belongs_to :user
  belongs_to :school

  default_scope -> { order('end_date DESC') }

  validates :user_id, presence: true
  validates :school_id, presence: true
  validates :degree, presence: true
  validates :field, presence: true


  def school_name
  	school.try(:name)
  end

  def school_name=(name)
  	self.school = School.find_or_create_by_name(name) if name.present?
  end
end
