class User < ActiveRecord::Base
  attr_accessible :first_name, :last_name, :email, :password, :password_confirmation,
    :avatar, :remove_avatar
  has_secure_password
  letsrate_rater

  # Stars Rater
  
  # has_many :microposts, dependent: :destroy
  # has_many :relationships, foreign_key: "follower_id", dependent: :destroy
  # has_many :followed_users, through: :relationships, source: :followed
  # has_many :reverse_relationships, foreign_key: "followed_id",
  #                                  class_name:  "Relationship",
  #                                  dependent:   :destroy
  # has_many :followers, through: :reverse_relationships, source: :follower

  # Avatar
  mount_uploader :avatar, AvatarUploader

  # Lessons
  has_many :lessons, dependent: :destroy

  # Profile Attributes

  # Groups
  has_many :memberships, dependent: :destroy
  has_many :groups, through: :memberships

  # Reviews
  has_many :reviews, foreign_key: "reviewer_id", dependent: :destroy
  has_many :reviewed_users, through: :reviews, source: :reviewed
  has_many :reverse_reviews, foreign_key: "reviewed_id",
                class_name: "Review", dependent: :destroy
  has_many :reviewers, through: :reverse_reviews

  # Callbacks
  before_save { email.downcase! }
  before_save :create_remember_token

  validates :first_name,  presence: true, length: { maximum: 30 }
  validates :last_name,  presence: true, length: { maximum: 30 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  validates :password, presence: true, length: { minimum: 6 }
  validates :password_confirmation, presence: true
  after_validation { self.errors.messages.delete(:password_digest) }

  # def feed
  #   Micropost.from_users_followed_by(self)
  # end

  # def following?(other_user)
  #   relationships.find_by_followed_id(other_user.id)
  # end

  # def follow!(other_user)
  #   relationships.create!(followed_id: other_user.id)
  # end

  # def unfollow!(other_user)
  #   relationships.find_by_followed_id(other_user.id).destroy
  # end

  def member?(group)
    memberships.find_by_group_id(group)
  end

  def join!(group)
    memberships.create!(:group_id => group.id)
  end

  def leave!(group)
    memberships.find_by_group_id(group).destroy
  end

  def to_s
    "#{first_name} #{last_name}"
  end

  def feed
    reviews
  end

  def self.text_search(query)
  if query.present?
    where("first_name ilike :q or last_name ilike :q", q: "%#{query}%")
  else
    scoped
  end
  end
  
  private

    def create_remember_token
      self.remember_token = SecureRandom.urlsafe_base64
    end
end
