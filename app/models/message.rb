class Message < ActiveRecord::Base
  attr_accessible :body, :subject, :sent, :user_id, :sender_id, :recipient_id

  belongs_to :user

  default_scope order: 'messages.created_at DESC'

  scope :sent, where(:sent => true)
  scope :received, where(:sent => false)
  scope :conversation, ->(sub) { where(:subject => sub) }

  validates :subject, presence: true, length: { maximum: 140 }
  validates :body, presence: true
  validates :user_id, presence: true

  def send_message(from, recipient)
      msg = self.dup
      msg.sent = false
      msg.user_id = recipient.id
      msg.save
    self.update_attributes :sent => true
  end

  def author
    sent? ? user : User.find(sender_id)
  end
end