class User < ActiveRecord::Base
  attr_accessible :first_name, :last_name, :email, :password, :password_confirmation
  has_secure_password
  
  # has_many :microposts, dependent: :destroy
  # has_many :relationships, foreign_key: "follower_id", dependent: :destroy
  # has_many :followed_users, through: :relationships, source: :followed
  # has_many :reverse_relationships, foreign_key: "followed_id",
  #                                  class_name:  "Relationship",
  #                                  dependent:   :destroy
  # has_many :followers, through: :reverse_relationships, source: :follower

  has_many :memberships, dependent: :destroy
  has_many :groups, through: :memberships

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

  private

    def create_remember_token
      self.remember_token = SecureRandom.urlsafe_base64
    end
end
