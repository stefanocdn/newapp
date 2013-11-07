class Lesson < ActiveRecord::Base
  attr_accessible :content, :price, :title

  belongs_to :user

  validates :user_id, presence: true
  validates :title, presence: true, length: { maximum: 140 }
  validates :content, presence: true
  validates :price, presence: true

  default_scope order: 'lessons.created_at DESC'
end
