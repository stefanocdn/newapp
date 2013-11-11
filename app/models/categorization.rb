class Categorization < ActiveRecord::Base
  attr_accessible :category_id

  belongs_to :lesson
  belongs_to :category

  validates :lesson_id, presence: true
  validates :category_id, presence: true
end
