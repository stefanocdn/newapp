class School < ActiveRecord::Base
  attr_accessible :name

  has_many :scholarships
  has_many :users, through: :scholarships

  validates :name, presence: true
  
end
